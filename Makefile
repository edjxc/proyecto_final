REGION := us-east-1
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)

init:
		@terraform init -reconfigure -upgrade

clean:
		@rm -rf .terraform terraform.*

plan:
		@terraform plan -var 'region=$(REGION)' -var 'account_id=$(ACCOUNT_ID)'

apply:
		@terraform apply -auto-approve -var 'aws_region=$(REGION)' -var 'account_id=$(ACCOUNT_ID)'

destroy:
		@terraform destroy -var 'region=$(REGION)' -var 'account_id=$(ACCOUNT_ID)'
