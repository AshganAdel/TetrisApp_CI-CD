module "vpc" {
  source = "./modules/vpc"
  cidr_vpc = var.vpc_cidr
  cidr_private = var.private_subnets_cidr
  public_subnet_cidr  =  var.public_subnets_cidr
  name_private = var.private_subnets_names
  name_public =  var.public_subnets_names
  vpc_name   =  var.vpc_name
  igw = var.igw_name
}

module "ec2" {
  source = "./modules/ec2"
  subnet_id = module.vpc.public_subnet_id
  public_ip_or_not = true
  ami = var.ami
  volume_size = var.volume_size
  key_name = var.ssh_key
  instance_type = var.ec2_types
  security_group_ids = [module.sg.sg_id]
  ec2_names = var.ec2_names
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "eks" {
  source = "./modules/eks"
  eks_subnets_ids = module.vpc.private_subnet_id
  eks_nodes_subnets_ids =  module.vpc.private_subnet_id
  security_group_ids = [module.sg.sg_id]
  enable_private_access = true
  enable_public_access =  true
  nodes_ec2_type  = var.worker_nodes_types
  node_group_name = var.group_nodes_name
  max_nodes = var.max_nodes
  min_nodes = var.min_nodes
  desired_nodes = var.desired_nodes
  k8s_version = var.k8s_version
  cluster_name = var.cluster_name
}

module "ecr" {
  source = "./modules/ecr"
  ecr_name = var.ecr_name
}
