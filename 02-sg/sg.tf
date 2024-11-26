module "db" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for DB MYSQL Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}

module "backend" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Backend Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "Backend"
}

module "frontend" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Frontend Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "Frontend"
}

###Bastion
module "bastion" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Bastion Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "Bastion"
}

###Ansible
module "ansible" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Ansible Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "ansible"
}

#DB is accepting connections from backend 
resource "aws_security_group_rule" "db_backend" {
    type        = "ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.backend.sg_id
}

#DB is accepting connections from bastion 
resource "aws_security_group_rule" "db_bastion" {
    type        = "ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.bastion.sg_id
}

#backend is accepting connections from frontend
resource "aws_security_group_rule" "backend_frontend" {
    type        = "ingress"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.frontend.sg_id
}

#backend is accepting connections from bastion
resource "aws_security_group_rule" "backend_bastion" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.bastion.sg_id
}

#backend is accepting connections from ansible
resource "aws_security_group_rule" "backend_ansible" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.ansible.sg_id
}
#frontend is accepting connections from public
resource "aws_security_group_rule" "frontend_public" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend.sg_id 
}

#frontend is accepting connections from bastion
resource "aws_security_group_rule" "frontend_bastion" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = module.frontend.sg_id 
    source_security_group_id = module.bastion.sg_id
}

#frontend is accepting connections from ansible
resource "aws_security_group_rule" "frontend_ansible" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = module.frontend.sg_id 
    source_security_group_id = module.ansible.sg_id
}

#bastion is accepting connections from public
resource "aws_security_group_rule" "bastion_public" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id 
}

#ansible is accepting connections from public
resource "aws_security_group_rule" "ansible_public" {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ansible.sg_id 
}