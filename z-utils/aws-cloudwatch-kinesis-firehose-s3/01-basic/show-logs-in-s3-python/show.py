import boto3
import gzip

s3 = boto3.resource("s3")
obj = s3.Object("cloudwatch-logs-from-firehose-bucket",
                "2023/08/14/19/terraform-kinesis-firehose-test-1-2023-08-14-19-17-00-8bb0d36f-57ae-47e5-a7bf-6cfdb48d19f2")
with gzip.GzipFile(fileobj=obj.get()["Body"]) as gzipfile:
    content = gzipfile.read()
print(content)
