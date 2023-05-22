import boto3

# Connect to S3 resource
s3 = boto3.resource("s3")

# Open the file we want to send and store it in a variable called data
data = open("sampletext.txt", "rb")

# Specify what bucket we are sending the file to
s3.Bucket("tech230-bradley-boto").put_object(Key="sampletext.txt", Body=data)
