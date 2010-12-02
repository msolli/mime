# Dragonfly relies on AWS::S3, but AWS::S3 doesn't support
# europeans buckets. (https://github.com/marcel/aws-s3/issues#issue/4)
# Can't be arsed to fork both aws::s3 and dragonfly, so we do it
# ugly bugly, but who cares.

AWS::S3::DEFAULT_HOST.replace "s3-eu-west-1.amazonaws.com"
