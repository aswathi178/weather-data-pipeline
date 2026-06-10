import json
import boto3
import uuid

s3 = boto3.client('s3')

BUCKET_NAME = 'weather-project-s3'

def lambda_handler(event, context):

    for record in event['Records']:

        data = record['dynamodb']['NewImage']

        file_name = f"{uuid.uuid4()}.json"

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=json.dumps(data)
        )

    return {
        'statusCode': 200
    }