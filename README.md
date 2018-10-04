<!--
Hi there,

Thank you for opening an issue. Please note that we try to keep the Terraform issue tracker reserved for bug reports and feature requests. For general usage questions, please see: https://www.terraform.io/community.html.

If your issue relates to a specific Terraform provider, please open it in the provider's own repository. The index of providers is at https://github.com/terraform-providers .
-->

### Terraform Version
<!---
Run `terraform -v` to show the version, and paste the result between the ``` marks below.

If you are not running the latest version of Terraform, please try upgrading because your issue may have already been fixed.
-->

```
Terraform v0.11.8
+ provider.azurerm v1.13.0
```

### Terraform Configuration Files
<!--
Paste the relevant parts of your Terraform configuration between the ``` marks below.

For large Terraform configs, please use a service like Dropbox and share a link to the ZIP file. For security, you can also encrypt the files using our GPG public key.
-->
See issue.tf

### Debug Output
<!--
Full debug output can be obtained by running Terraform with the environment variable `TF_LOG=trace`. Please create a GitHub Gist containing the debug output. Please do _not_ paste the debug output in the issue, since debug output is long.

Debug output may contain sensitive information. Please review it before posting publicly, and if you are concerned feel free to encrypt the files using the HashiCorp security public key.
-->
See output.log

### Expected Behavior
<!--
What should have happened?
-->
The load balancer, backend pool, probe and rule should be created.

### Actual Behavior
<!--
What actually happened?
-->
The backend pool is not created:
```
Error: Error applying plan:

1 error(s) occurred:

* azurerm_lb_backend_address_pool2018-10-03T16:41:32.155+0100 [DEBUG] plugin: plugin process exited: path=C:\Users\Me\workspace\Terraform-Azure-Issue\.terraform\plugins\windows_amd64\terraform-provider-azurerm_v1.16.0_x4.exe
.example-backendpool: 1 error(s) occurred:

* azurerm_lb_backend_address_pool.example-backendpool: Error Creating/Updating Load Balancer "example-lb" (Resource Group "terraform-example-resource-group"): network.LoadBalancersClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=500 Code="InternalServerError" Message="An error occurred." Details=[]

Terraform does not automatically rollback in the face of errors.
Instead, your Terraform state file has been partially updated with
any resources that successfully completed. Please address the error
above and apply again to incrementally change your infrastructure.
```

### Steps to Reproduce
<!--
Please list the full steps required to reproduce the issue, for example:
1. `terraform init`
2. `terraform apply`
-->
1. `$ENV:TF_LOG="trace"
2. `terraform init`
3. `terraform apply`

### Additional Context
<!--
Are there anything atypical about your situation that we should know? For example: is Terraform running in a wrapper script or in a CI system? Are you passing any unusual command line options or environment variables to opt-in to non-default behavior?
-->
If you comment out the loadbalancer rule, Terraform will create the backend pool. However, uncommenting the rule after successfully doing this will result in a similar error when you try to apply the rule. If you successfully apply the backend pool, you *can* manually add the loadbalancer rules to the loadbalancer in the portal. However, if you apply the rules and the backend pool fails to create, the rules are left in a broken state as they are supposed to be created after the backend pool.

### References
<!--
Are there any other GitHub issues (open or closed) or Pull Requests that should be linked here? For example:

- #6017

-->
