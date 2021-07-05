Creating cluster of 2 EC2 with html files created at boot using python.

These 2 EC2 are behind ALB in a custom made VPC with 2 subnets ( because ALB requires two ), one public, the other one not

How to run this using GitHub Action:

1.Create a PR

2.edit the access_key and the secret_key in main.tf

How to run this locally:

1.clone the repo

2.edit the access_key and the secret_key in main.tf

4.install Go with the latest version

5.go mod init test

6.go get -u github.com/gruntwork-io/terratest/modules/terraform

7.go test -v
