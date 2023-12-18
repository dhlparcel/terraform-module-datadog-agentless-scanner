<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_repo_url"></a> [agent\_repo\_url](#input\_agent\_repo\_url) | Specifies the agent distribution channel | `string` | `"datad0g.com"` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Specifies the API keys required by the Datadog Agent to submit vulnerabilities to Datadog | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Specifies the hostname the agentless-scanning agent will report as | `string` | n/a | yes |
| <a name="input_scanner_version"></a> [scanner\_version](#input\_scanner\_version) | Specifies the agentless scanner version installed | `string` | `"50.0~rc.7~agentless~scanner~2023121801"` | no |
| <a name="input_site"></a> [site](#input\_site) | By default the Agent sends its data to Datadog US site. If your organization is on another site, you must update it. See https://docs.datadoghq.com/getting_started/site/ | `string` | `"datadoghq.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_install_sh"></a> [install\_sh](#output\_install\_sh) | The installation script for the Datadog agentless-scanner |
<!-- END_TF_DOCS -->
