# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("${path.module}/private-key/terraform-key.pem")
  }

  provisioner "file" {
    source      = "private-key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem"
    ]
  }

  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure  = continue
  }

  /*  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure  = continue
  }
*/
}

# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)