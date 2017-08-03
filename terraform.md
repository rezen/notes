# Terraform
If terraform isn't working check for interopolation fails (eg ${count.index})

```sh
terraform plan \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
  ```
terraform import digitalocean_ssh_key.default 2xxxx
terraform import digitalocean_tag.scanner scanner

- https://www.digitalocean.com/community/tutorials/how-to-deploy-a-node-js-app-using-terraform-on-ubuntu-14-04
- http://ottogiron.me/2015/12/15/using-terraform-with-digitalocean/
- https://www.terraform.io/docs/configuration/interpolation.html
- http://blog.scottlowe.org/2016/05/06/using-terraform-etcd2-openstack/
- https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9#.wa74xx816
- https://blog.bennycornelissen.nl/terraform-tricks-override-variables/
- https://heap.engineering/terraform-gotchas/
- https://charity.wtf/tag/terraform/