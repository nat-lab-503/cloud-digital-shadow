provider "aws" {
  region = "us-east-1"
}

# 1. VPC para simular rede corporativa
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "Corp-Prod-VPC" }
}

# 2. Subnet Pública (onde o perímetro "vaza")
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "External-Facing-Subnet" }
}

# 3. Bucket S3 (Alvo do OSINT)
resource "aws_s3_bucket" "sensitive_data" {
  bucket = "research-data-internal-7721" # Nome que tentaremos "adivinhar" via OSINT
}

# 4. EC2 Instance (O servidor com metadados)
resource "aws_instance" "web_server" {
  ami           = "ami-0f3caa1cf4417e51b" # Amazon Linux 2 (Verifique se é a atual na sua região)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "Web-Server-Internal-ID-442"
    AppID       = "Finance-App-01"
    ConfigPath  = "/etc/apps/finance/db.conf" # TAG perigosa que vaza info interna
  }
}