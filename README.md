## Pre-requisites

You need to install Terraform and Packer binaries. If you are using MAC-OS install them with brew, if you are using linux please visit https://www.packer.io/intro/getting-started/install.html and https://www.terraform.io/intro/getting-started/install.html.

## Infrastructure deployment

    $ cd packer
    #Modify the .env file with your AWS credentials
    $ source .env
    #Validate the JSON  builder
    $ packer validate bank_packer.json
    $ packer build bank_packer.json
    $ cd../terraform/
    # First modify your variables.tf file with data that matches with your AWS account
    $ terraform plan -out plan
    $ terraform apply plan


## Deployment

Once the infrastructure was deployed. You can execute the deploy.sh script located inside the EC2 machine to deliver new changes as many times you want or need. This could be improved by a Jenkins-Job implementation to execute (using a trigger) the script every time the master branch acquires new changes.

## Proxy-Nginx
The EC2 instance it will be launched with an Nginx configuration that is in charge of masks the 4000 port by the 80 port. The configuration is located in the default file into the packer folder.
