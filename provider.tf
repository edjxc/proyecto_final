provider "aws" {
  alias                    = "pipeline"
  region                   = data.aws_region.current.id
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
}


provider "aws" {
  alias                    = "dev"
  region                   = data.aws_region.current.id
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]

  # MFA token
  # token      = var.mfa_token

  assume_role {
    # El ARN del ROL dentro de la cuenta externa para AssumeRole.
    role_arn = "arn:aws:iam::797796841888:role/MasterAccount_Admin_AccessRole"

    # Opcional: El "external ID" que es requerido por la cuenta externa
    external_id = "42vDVjakwRj5Svwjtk5rCffpnfk5XofwgZ4F2eZPCMaVfsx2eYigVyuZQXyc"

  }
}

provider "aws" {
  alias                    = "pro"
  region                   = data.aws_region.current.id
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]

  # MFA token
  # token      = var.mfa_token

  assume_role {
    # El ARN del ROL dentro de la cuenta externa para AssumeRole.
    role_arn = "arn:aws:iam::254183230632:role/MasterAccount_Admin_AccessRole"

    # Opcional: El "external ID" que es requerido por la cuenta externa
    external_id = "bF7HZXY9Zg4wLMhvYZh4xJRDRxE2pxS2Lu5rizz5zDZa3K4v553ebfnEuowY"

  }
}
