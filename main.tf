provider "aws" {
    region = "us-east-1"
    access_key = "***"
    secret_key = "***"
}

// CREATING VPC, SUBNETS, INTERNET GATEWAY AND ROUTING TABLE

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "Test"
    }
}

resource "aws_subnet" "main" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.103.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "Test"
    }

}

        // Creating second subnet, because ALB requires two subnets
resource "aws_subnet" "main2" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.102.0/24"
    map_public_ip_on_launch = false
    tags = {
        Name = "Test2"
    }

}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main"
    }

}

resource "aws_default_route_table" "main" {
    default_route_table_id = aws_vpc.main.default_route_table_id
    tags = {
        "Name" = "main"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}

// CREATING TWO SECURITY GROUPS

resource "aws_security_group" "allow_inbound_http" {
    name        = "allow-inbound-http"
    description = "Allow inbound HTTP traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_outbound_traffic" {
    name        = "allow-outbound-traffic"
    description = "Allow all outbound traffic"
    vpc_id      = aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


// CREATING ALB 

resource "aws_lb" "web" {
    name = "web-alb"
    internal = false
    subnets         = [aws_subnet.main.id,aws_subnet.main2.id]
    security_groups = [aws_security_group.allow_inbound_http.id,aws_security_group.allow_outbound_traffic.id]
    load_balancer_type = "application"
}

resource "aws_lb_target_group" "web" {
    name     = "web-alb-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "web_01" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_01.id
}

resource "aws_lb_target_group_attachment" "web_02" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_02.id
}

resource "aws_lb_listener" "web" {
    load_balancer_arn = aws_lb.web.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.web.arn
    }
}

// CREATING 2 EC2

resource "aws_instance" "web_01" {
    ami                    = "ami-0d5eff06f840b45e9"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.main.id
    tags = {
        Name = "web-server-01"
  }

    vpc_security_group_ids = [
        aws_security_group.allow_inbound_http.id,
        aws_security_group.allow_outbound_traffic.id,
  ]

    user_data = <<EOF
#!/bin/bash
echo 'f = open("index1.html", "x")' | tee -a run.py
echo 'f.write("web-server-01")' | tee -a run.py
echo 'f.close()' | tee -a run.py
python3 run.py

sudo yum -y update
sudo amazon-linux-extras install nginx1 -y
sudo service nginx start

cp index1.html /usr/share/nginx/html/index1.html 
EOF

}

resource "aws_instance" "web_02" {
    ami                    = "ami-0d5eff06f840b45e9"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.main.id
    tags = {
        Name = "web-server-02"
  }

    vpc_security_group_ids = [
        aws_security_group.allow_inbound_http.id,
        aws_security_group.allow_outbound_traffic.id,
  ]

    user_data = <<EOF
#!/bin/bash
echo 'f = open("index2.html", "x")' | tee -a run.py
echo 'f.write("web-server-02")' | tee -a run.py
echo 'f.close()' | tee -a run.py
python3 run.py

sudo yum -y update
sudo amazon-linux-extras install nginx1 -y
sudo service nginx start

cp index2.html /usr/share/nginx/html/index2.html 
EOF

}

output "aws-web-01" {
  value = aws_instance.web_01.public_ip
}

output "aws-web-02" {
  value = aws_instance.web_02.public_ip
}

output "aws-lb" {
  value = aws_lb.web.dns_name
}


