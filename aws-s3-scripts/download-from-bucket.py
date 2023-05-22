import boto3

# Connect to S3 client
s3 = boto3.client("s3")

# Download from S3 bucket with bucket name, filename and download filename
s3.download_file("tech230-bradley-boto", "sampletext.txt", "sampletext1.txt")

print(s3.download_file)
