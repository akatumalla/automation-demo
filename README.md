## Purpose
The repository demonstrates automation of infrastructure and code deployment using ```Terraform```,```Ansible``` and ```CircleCI```.

The final output is a very simple Go server hosted on an AWS EC2 instance. The Go code is located [here](https://github.com/akatumalla/go-simple-server).

## Pre-requisites

To run the terraform workbook, your machine should have below installations:

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)


## Run the demo
1. Clone the repository onto your local machine.
```shell
git clone https://github.com/akatumalla/automation-demo.git
```

2. Change directory
```shell
cd automation-demo
```

3. Run the commands below in the specified order.

  1. Initialize terraform, this will download the necessary providers
  ```shell
  terraform init
  ```
  2. To view the resources being deployed by terraform, you can use the subcommand ```plan``` as below. This step can be skipped. 
  ```shell
  terraform plan
  ```
  3. Finally, to perform the actual execution of actions proposed.
  ```shell
  terraform apply
  ```

1. Please remember to destroy the resources deployed in the steps above

```shell
terraform destroy
```

## Verify deployment

Copy the domain name displayed as output above onto your browser.

```shell
http://<copy displayed domain name here>
```
