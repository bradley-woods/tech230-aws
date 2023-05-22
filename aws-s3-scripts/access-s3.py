import boto3

# Connect to S3 resource
s3 = boto3.resource("s3")

# List buckets
for bucket in s3.buckets.all():
    print(bucket.name)
