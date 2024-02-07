# Create AWS RDS Database
module "rdsdb" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier = var.db_instance_identifier

  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  manage_master_user_password = false
  port                        = 3306

  multi_az               = true
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.rdsdb_sg.security_group_id]

  engine               = "mysql"
  engine_version       = "8.0.35"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.common_tags
  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}
