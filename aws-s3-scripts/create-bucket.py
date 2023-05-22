import boto3

# Connect to S3 client
s3 = boto3.client("s3")

# Create an S3 bucket
bucket_name = s3.create_bucket(Bucket="tech230-bradley-boto", CreateBucketConfiguration={"LocationConstraint": "eu-west-1"})

print(bucket_name)
