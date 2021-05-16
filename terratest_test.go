package test

import (
	"testing"

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

}

