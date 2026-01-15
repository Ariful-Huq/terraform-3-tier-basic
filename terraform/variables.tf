# Variables for BMI Health Tracker Terraform Configuration

# ===========================
# AWS Configuration
# ===========================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_profile" {
  description = "AWS named profile to use"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ===========================
# EC2 Instance Configuration
# ===========================

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "terraform-bmi-health-tracker-server"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^t[2-3]\\.(micro|small|medium)", var.instance_type))
    error_message = "Instance type must be a valid t2 or t3 type (micro, small, or medium recommended)."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string

  # Default: Ubuntu 24.04 LTS in ap-southeast-2
  default     = "ami-0b8d527345fdace59"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# ===========================
# Network Configuration
# ===========================

variable "vpc_id" {
  description = "VPC ID where the instance will be launched"
  type        = string
}


variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to attach to the instance"
  type        = string
}

# ===========================
# Database Configuration
# ===========================

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "bmidb"
}

variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "bmi_user"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}

# ===========================
# Application Configuration
# ===========================

variable "deployment_script_path" {
  description = "Path to the deployment script (IMPLEMENTATION_AUTO.sh)"
  type        = string
  default     = "../IMPLEMENTATION_AUTO.sh"
}

# ===========================
# Additional Tags
# ===========================

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
