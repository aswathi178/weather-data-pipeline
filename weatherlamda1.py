import json
import urllib.request
import boto3
from datetime import datetime


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('weather_data') 

def lambda_handler(event, context):
    city = "London"
    api_key = "a1a60b19ef4db5272d540f39383e52c5"
    
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
    
    try:
        response = urllib.request.urlopen(url)
        data = json.loads(response.read())
        
        
        table.put_item(
            Item={
                'city': city,
                'timestamp': str(datetime.now()), 
                'temperature': str(data['main']['temp']),
                'humidity': str(data['main']['humidity']),
                'weather_desc': data['weather'][0]['description']
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Data successfully written to DynamoDB!')
        }
        
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }