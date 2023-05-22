import boto3

# Connect to EC2 resource
ec2 = boto3.resource("ec2")

# List instances
for instance in ec2.instances.all():
    print(instance.name)