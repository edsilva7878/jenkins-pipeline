variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"  # Ou a região correta
}


variable "grupo_admin_nome" {
  description = "Nome do grupo de administradores"
  type        = string
  default     = "Admin"
}

variable "novo_usuario_nome" {
  description = "Nome do novo usuário IAM"
  type        = string
  default     = "rickteste-tf@email.com"
}

variable "novo_usuario_descricao" {
  description = "Descrição para o novo usuário IAM"
  type        = string
  default     = "Usuário criado via Terraform"
}

variable "senha_comprimento" {
  description = "Comprimento da senha gerada automaticamente"
  type        = number
  default     = 20
}

variable "arquivo_credenciais_nome" {
  description = "Nome do arquivo CSV de credenciais"
  type        = string
  default     = "credentials.csv"
}