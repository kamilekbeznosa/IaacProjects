import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Uruchamianie raportu kosztów AWS...")
    
    dummy_costs = {
        "EC2": "1.24 USD",
        "S3": "0.05 USD",
        "Total": "1.29 USD"
    }
    
    logger.info(f"Podsumowanie kosztów: {json.dumps(dummy_costs)}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Raport kosztów został wygenerowany pomyślnie!')
    }