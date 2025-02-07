resource "aws_vpc" "main" {
    cidr_block="10.0.0.0/16"
    tags={
        Name="terraform-vpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id =aws_vpc.main.id
    cidr_block ="10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags ={
        Name = "public-subnet"
    }
  
}

resource "aws_subnet" "private" {
    vpc_id =aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags ={
        Name = "private-subnet"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags ={
        Name = "terraform-igw"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
  
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id

  
}

resource "aws_instance" "web" {
    ami = "ami-05fa46471b02db0ce"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    key_name = "my-key-pair"
    tags = {
        Name = "web-server"
    }

  
}

resource "aws_lb" "app" {
    name = "terraform-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet_public.id]

    tags = {
        Name = "terraform-alb"
    }
  
}

resource "aws_lb_target_group" "web_tg" {
    name = "web-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
  
}

resource "aws_lb_listener" "web_listner" {
    load_balancer_arn = aws_lb.app.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web_tg.arn
    }
  
}