package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Please enter the correct path in the command below
		TerraformDir: "./",
	})

	// Commented the below line, to make sure everything was created correctly 
	// defer terraform.Destroy(t, terraformOptions)

	// The below command is terraform init and terraform apply with -auto-approve
	terraform.InitAndApply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "aws-web-01")
	url := fmt.Sprintf("http://%s:80/index1.html", publicIp)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "web-server-01", 30, 5*time.Second)

	publicIp2 := terraform.Output(t, terraformOptions, "aws-web-02")
	url2 := fmt.Sprintf("http://%s:80/index2.html", publicIp2)
	http_helper.HttpGetWithRetry(t, url2, nil, 200, "web-server-02", 30, 5*time.Second)
	
}
