# VPC
module "vpc" {
  source = "../../../../../../iac-modules/networking/vpc"

  project     = var.project
  environment = var.environment
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  common_tags = var.common_tags
}

# SUBNETS
module "subnets" {
  source = "../../../../../../iac-modules/networking/subnets"

  project                  = var.project
  environment              = var.environment
  region                   = var.region
  vpc_id                   = module.vpc.vpc_id
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  common_tags              = var.common_tags
}

# INTERNET GATEWAY
module "internet_gateway" {
  source = "../../../../../../iac-modules/networking/internet_gateway"

  project     = var.project
  environment = var.environment
  region      = var.region
  vpc_id      = module.vpc.vpc_id
  common_tags = var.common_tags
}

# EIP
module "eip" {
  source = "../../../../../../iac-modules/networking/eip"

  project            = var.project
  environment        = var.environment
  region             = var.region
  availability_zones = var.availability_zones
  common_tags        = var.common_tags
}

# NAT GATEWAY
module "nat_gateway" {
  source = "../../../../../../iac-modules/networking/nat_gateway"

  project             = var.project
  environment         = var.environment
  region              = var.region
  availability_zones  = var.availability_zones
  eip_allocation_ids  = module.eip.eip_allocation_ids
  public_subnet_ids   = module.subnets.public_subnet_ids
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  common_tags         = var.common_tags
}

# ROUTE TABLE
module "route_table" {
  source = "../../../../../../iac-modules/networking/route_table"

  project                = var.project
  environment            = var.environment
  region                 = var.region
  vpc_id                 = module.vpc.vpc_id
  availability_zones     = var.availability_zones
  public_subnet_ids      = module.subnets.public_subnet_ids
  private_app_subnet_ids = module.subnets.private_app_subnet_ids
  private_db_subnet_ids  = module.subnets.private_db_subnet_ids
  internet_gateway_id    = module.internet_gateway.internet_gateway_id
  nat_gateway_ids        = module.nat_gateway.nat_gateway_ids
  common_tags            = var.common_tags
}
