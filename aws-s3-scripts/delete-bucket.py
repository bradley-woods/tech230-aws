import boto3

# Connect to S3 resource
s3 = boto3.resource("s3")

# Specify what bucket to delete
bucket = s3.Bucket("tech230-bradley-boto")
response = bucket.delete()

print(response)
