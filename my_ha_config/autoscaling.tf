resource "aws_launch_configuration" "web" {
   name          = "web-lc"
   image_id      = "ami-0c55b159cbfafe1f0"  # AMI ID for the instance
   instance_type = "t2.micro"               # EC2 instance type
   key_name      = "my-key-pair"          # SSH key pair to access the instances

   lifecycle {
     create_before_destroy = true           # Ensures that a new launch configuration is created before destroying the old one
   }
}

resource "aws_autoscaling_group" "web" {
   launch_configuration = aws_launch_configuration.web.id  # References the ID of the Launch Configuration
   min_size             = 1  # Minimum number of instances in the ASG
   max_size             = 3  # Maximum number of instances in the ASG
   desired_capacity     = 2  # Desired number of instances in the ASG
   vpc_zone_identifier  = [aws_subnet.public.id]  # Subnet to launch the instances in

   tag {
     key                 = "Name"
     value               = "web-instance"
     propagate_at_launch = true  # Ensures the "Name" tag is applied to all instances at launch
   }
}
