import boto3

# Connect to S3 resource
s3 = boto3.resource("s3")

# Delete a file in a specific bucket
s3.Object("tech230-bradley-boto", "sampletext.txt").delete()
