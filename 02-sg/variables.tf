variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "sg_description" {
    default = "SG group for Instances"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}