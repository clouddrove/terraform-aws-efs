// Managed By : CloudDrove
// Description : This Terratest is used to test the Terraform EFS module.
// Copyright @ CloudDrove. All Right Reserved.

package test

import (
	"testing"
	//"strings"
	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEFS(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// Source path of Terraform directory.
		TerraformDir: "../_example",
		Upgrade:      true,
	}

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	keyArn := terraform.Output(t, terraformOptions, "efs_arn")

	// Verify we're getting back the outputs we expect
	assert.Contains(t, keyArn, "arn:aws:elasticfilesystem")
}
