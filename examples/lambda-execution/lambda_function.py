def lambda_handler(event, context):
    """
    Simple Lambda function handler for testing
    """
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda!'
    }
