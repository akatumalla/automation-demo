## Purpose
The repository demonstrates an example of infrastructure automation using Terraform, Ansible and CircleCI.

The actual repository being deployed is a very simple Go server hosted [here](https://github.com/akatumalla/go-simple-server).

## Pre-requisites

To run the terraform workbook, your machine should have below installations:

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)


## Run
Clone the repo onto your local machine.
```shell
git clone https://github.com/akatumalla/terraform-aws.git
```

Change directory
```shell
cd terraform-aws
```

Run the commands below in the order.

Initialize terraform, this will download the necessary providers
```shell
terraform init
```
To view the resources being deployed by terraform, you can use the subcommand ```plan``` as below. This step can be skipped. 
```shell
terraform plan
```
Finally, to perform the actual execution of actions proposed.
```shell
terraform apply
```

Please remember to destroy the resources once done using below:

```shell
terraform destroy
```

## Check execution

```shell
http://<copy displayed IP here>:11000
```
