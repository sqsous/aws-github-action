

Creating S3 bucket with Terraform and TerraTest using github Action

Creating two files with timestamps and adding them to the bucket

How to run this using GitHub Action:

1.Create a PR

2.edit the access_key and the secret_key in main.tf

(optional) 3.edit bucket name in main.tf, in lines 7,8,14,18,22,26

(optional) 4.edit the name of the pushed files in s3 in both run.sh, in lines 1,2,5,6 and in main.tf, in lines 15,16,23,24

How to run this locally:

1.clone the repo

2.edit the access_key and the secret_key in main.tf

3.chmod +x run.sh, then ./run.sh

4.install Go with the latest version

5.go mod init test

6.go get -u github.com/gruntwork-io/terratest/modules/terraform

7.go test -v
