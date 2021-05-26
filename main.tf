provider "aws" {
    region = "us-east-1"
    access_key = "access-key"
    secret_key = "secret-key"
}

resource "aws_s3_bucket" "s3-sima" {
    bucket = "s3-sima"
    acl    = "private"

}

resource "aws_s3_bucket_object" "object1" {
    bucket = "s3-sima"
    key    = "test1.txt"
    source = "test1.txt"

    depends_on = [aws_s3_bucket.s3-sima]
}

resource "aws_s3_bucket_object" "object2" {
    bucket = "s3-sima"
    key    = "test2.txt"
    source = "test2.txt"

    depends_on = [aws_s3_bucket.s3-sima]
}
