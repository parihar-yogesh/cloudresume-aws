import json
import os

import boto3

TABLE_NAME = os.environ["TABLE_NAME"]
COUNTER_ID = "visitors"

table = boto3.resource("dynamodb").Table(TABLE_NAME)


def handler(event, context):
    # ADD creates the attribute at 0 if it doesn't exist yet, then increments
    result = table.update_item(
        Key={"id": COUNTER_ID},
        UpdateExpression="ADD visit_count :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"count": int(result["Attributes"]["visit_count"])}),
    }