#################### VPC Creation #################################

resource "aws_vpc" "my_vpc1" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "tag_my_vpc1"
  }
}

######################## Subnet creation #########################################

resource "aws_subnet" "my_subnet1" {
  vpc_id     = aws_vpc.my_vpc1.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "tag_my_subnet1"
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id     = aws_vpc.my_vpc1.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "tag_my_subnet2"
  }
}

######################## Internet gateway creation #####################################
resource "aws_internet_gateway" "my_internetgateway" {
  vpc_id = aws_vpc.my_vpc1.id

  tags = {
    Name = "tag_my_internetgateway"
  }
}


###################### Route table creation ###############################################
resource "aws_route_table" "my_routetable" {
  vpc_id = aws_vpc.my_vpc1.id

  route =[]
    
  tags = {
    Name = "tag_my_routetable"
  }
}

####################### Route creation #####################################################

resource "aws_route" "my_aws_route" {
  route_table_id            = aws_route_table.my_routetable.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_internetgateway.id
  depends_on                = [aws_route_table.my_routetable]

}

######################## Subnet Associate ###################################

resource "aws_route_table_association" "my_routetable_association1" {
  subnet_id      = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.my_routetable.id
}


#################### Security group creation ##############################################

resource "aws_security_group" "my_securitygroup" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.my_vpc1.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "tag_my_securitygroup"
  }
}

################################ Ec2 creation ###############################################


resource "aws_instance" "my_ec2_01" {
  ami           = "ami-092b43193629811af"
  instance_type = "t2.micro"
  key_name = "keypair_ohio_region"
  subnet_id = aws_subnet.my_subnet1.id

  tags = {
    Name = "tag_my_ec2_01"
  }
}