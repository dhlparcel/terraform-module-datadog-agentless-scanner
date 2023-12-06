# Terraform Datadog Side Scanner Module

This Terraform module provides a simple and reusable configuration for installing a Datadog side-scanner.

## Prerequisites

Before using this module, make sure you have the following:

1. [Terraform](https://www.terraform.io/) installed on your local machine.
2. AWS credentials configured with the necessary permissions.

## Usage

To use this module in your Terraform configuration, add the following code:

```hcl
module "sidescanner" {
  source = "github.com/DataDog/terraform-datadog-sidescanner"

  api_key               = "YOUR_API_KEY"
  instance_profile_name = ""
}
``````

## Example

For a complete example, refer to the [examples](./examples/) directory in this repository.