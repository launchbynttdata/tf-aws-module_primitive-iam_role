package testimpl

import (
	"context"
	"encoding/json"
	"net/url"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const (
	failedToGetRoleMsg = "Failed to get IAM role"
	failedToDecodeMsg  = "Failed to URL decode assume role policy document"
	failedToParseMsg   = "Failed to parse assume role policy document"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	iamClient := GetAWSIAMClient(t)

	roleArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "role_arn")
	roleName := terraform.Output(t, ctx.TerratestTerraformOptions(), "role_name")
	roleId := terraform.Output(t, ctx.TerratestTerraformOptions(), "role_id")

	t.Run("TestIAMRoleExists", func(t *testing.T) {
		testIAMRoleExists(t, iamClient, roleArn, roleName, roleId)
	})

	t.Run("TestIAMRoleAssumeRolePolicy", func(t *testing.T) {
		testIAMRoleAssumeRolePolicy(t, iamClient, roleName)
	})

	t.Run("TestIAMRoleAssumeRolePolicyPrincipals", func(t *testing.T) {
		testIAMRoleAssumeRolePolicyPrincipals(t, iamClient, roleName)
	})

	t.Run("TestIAMRoleProperties", func(t *testing.T) {
		testIAMRoleProperties(t, iamClient, roleName)
	})

	t.Run("TestIAMRoleTags", func(t *testing.T) {
		var roleTags map[string]interface{}
		terraform.OutputStruct(t, ctx.TerratestTerraformOptions(), "role_tags", &roleTags)
		roleTagsJSON, _ := json.Marshal(roleTags)
		testIAMRoleTags(t, iamClient, roleName, string(roleTagsJSON))
	})
}

func testIAMRoleExists(t *testing.T, iamClient *iam.Client, roleArn, roleName, roleId string) {
	role, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, failedToGetRoleMsg)
	assert.Equal(t, roleArn, *role.Role.Arn, "Expected role ARN did not match actual ARN!")
	assert.Equal(t, roleName, *role.Role.RoleName, "Expected role name did not match actual name!")
	assert.Equal(t, roleId, *role.Role.RoleId, "Expected role ID did not match actual ID!")
}

func testIAMRoleAssumeRolePolicy(t *testing.T, iamClient *iam.Client, roleName string) {
	role, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, failedToGetRoleMsg)

	assumeRolePolicy := parseAssumeRolePolicy(t, *role.Role.AssumeRolePolicyDocument)

	// Verify basic structure of assume role policy
	assert.Contains(t, assumeRolePolicy, "Version", "Assume role policy should have Version")
	assert.Contains(t, assumeRolePolicy, "Statement", "Assume role policy should have Statement")

	statements, ok := assumeRolePolicy["Statement"].([]interface{})
	require.True(t, ok, "Policy should contain Statement array")
	require.Greater(t, len(statements), 0, "Policy should have at least one statement")

	// Verify the first statement has the expected structure for role assumption
	statement := statements[0].(map[string]interface{})
	assert.Contains(t, statement, "Effect", "Statement should have Effect")
	assert.Contains(t, statement, "Action", "Statement should have Action")
	assert.Contains(t, statement, "Principal", "Statement should have Principal for role assumption")

	// Verify this is an assume role policy
	effect, ok := statement["Effect"].(string)
	require.True(t, ok, "Effect should be a string")
	assert.Equal(t, "Allow", effect, "Effect should be Allow for assume role policy")
}

func testIAMRoleAssumeRolePolicyPrincipals(t *testing.T, iamClient *iam.Client, roleName string) {
	role, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, failedToGetRoleMsg)

	assumeRolePolicy := parseAssumeRolePolicy(t, *role.Role.AssumeRolePolicyDocument)

	statements, ok := assumeRolePolicy["Statement"].([]interface{})
	require.True(t, ok, "Policy should contain Statement array")
	require.Greater(t, len(statements), 0, "Policy should have at least one statement")

	statement := statements[0].(map[string]interface{})
	principal, exists := statement["Principal"]
	require.True(t, exists, "Statement should have Principal")

	verifyServicePrincipal(t, principal)
}

func testIAMRoleProperties(t *testing.T, iamClient *iam.Client, roleName string) {
	role, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, failedToGetRoleMsg)

	// Verify role properties
	assert.NotNil(t, role.Role.CreateDate, "Role should have a creation date")
	assert.NotNil(t, role.Role.Path, "Role should have a path")

	// Check if max session duration is set (default is 3600 seconds, example sets 7200)
	if role.Role.MaxSessionDuration != nil {
		// Based on the example, it should be 7200 seconds (2 hours)
		assert.Equal(t, int32(7200), *role.Role.MaxSessionDuration, "Expected max session duration to be 7200 seconds")
	}
}

func testIAMRoleTags(t *testing.T, iamClient *iam.Client, roleName, roleTags string) {
	if roleTags == "" {
		return
	}

	// Parse the tags JSON
	var expectedTags map[string]interface{}
	err := json.Unmarshal([]byte(roleTags), &expectedTags)
	require.NoError(t, err, "Failed to parse expected tags")

	// Get role from AWS to check actual tags
	role, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoError(t, err, failedToGetRoleMsg)

	// Check if tags match expectations
	if len(expectedTags) > 0 {
		assert.NotNil(t, role.Role.Tags, "Role should have tags")

		// Convert AWS tags to map for comparison
		actualTags := make(map[string]string)
		for _, tag := range role.Role.Tags {
			actualTags[*tag.Key] = *tag.Value
		}

		// Verify expected tags exist
		for key, value := range expectedTags {
			assert.Equal(t, value, actualTags[key], "Tag %s should have expected value", key)
		}
	}
}

func parseAssumeRolePolicy(t *testing.T, policyDocument string) map[string]interface{} {
	// AWS returns URL-encoded policy documents, so we need to decode them
	decodedDocument, err := url.QueryUnescape(policyDocument)
	require.NoError(t, err, failedToDecodeMsg)

	// Parse the assume role policy document
	var assumeRolePolicy map[string]interface{}
	err = json.Unmarshal([]byte(decodedDocument), &assumeRolePolicy)
	require.NoError(t, err, failedToParseMsg)

	return assumeRolePolicy
}

func verifyServicePrincipal(t *testing.T, principal interface{}) {
	// Check if principal contains Service (for service principals like EC2)
	principalMap, ok := principal.(map[string]interface{})
	if !ok {
		return
	}

	service, exists := principalMap["Service"]
	if !exists {
		return
	}

	// Verify service principal exists
	assert.NotNil(t, service, "Service principal should be defined")

	// If it's an array of services
	if serviceArray, ok := service.([]interface{}); ok {
		assert.Greater(t, len(serviceArray), 0, "Should have at least one service principal")
		// Verify at least one valid AWS service principal exists
		foundValidService := false
		validServiceSuffixes := []string{".amazonaws.com"}
		for _, svc := range serviceArray {
			if svcStr, ok := svc.(string); ok {
				for _, suffix := range validServiceSuffixes {
					if len(svcStr) > len(suffix) && svcStr[len(svcStr)-len(suffix):] == suffix {
						foundValidService = true
						break
					}
				}
				if foundValidService {
					break
				}
			}
		}
		assert.True(t, foundValidService, "Expected to find at least one valid AWS service principal ending with .amazonaws.com")
	} else if serviceStr, ok := service.(string); ok {
		// Single service principal - verify it's a valid AWS service
		assert.True(t, len(serviceStr) > 14 && serviceStr[len(serviceStr)-14:] == ".amazonaws.com",
			"Expected a valid AWS service principal ending with .amazonaws.com, got: %s", serviceStr)
	}
}

func GetAWSIAMClient(t *testing.T) *iam.Client {
	awsIAMClient := iam.NewFromConfig(GetAWSConfig(t))
	return awsIAMClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
