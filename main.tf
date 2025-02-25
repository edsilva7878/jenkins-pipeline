provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::901392891750:role/embratel.atendimento"
  }
}

# Obter o ID da conta AWS
data "aws_caller_identity" "current" {}

# Criação do grupo Admin
resource "aws_iam_group" "grupo_admin" {
  name = var.grupo_admin_nome
}

# Anexar política de administrador ao grupo
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.grupo_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Anexar política para permitir que o usuário altere sua própria senha
resource "aws_iam_group_policy_attachment" "change_password_policy" {
  group      = aws_iam_group.grupo_admin.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# Criação do usuário IAM
resource "aws_iam_user" "novo_usuario" {
  name = var.novo_usuario_nome

  tags = {
    Descricao = var.novo_usuario_descricao
  }
}

# Configurar perfil de login para o usuário
resource "aws_iam_user_login_profile" "perfil_login" {
  user                    = aws_iam_user.novo_usuario.name
  password_length         = var.senha_comprimento
  password_reset_required = true
}

# Adicionar usuário ao grupo Admin
resource "aws_iam_user_group_membership" "membro_admin" {
  user   = aws_iam_user.novo_usuario.name
  groups = [aws_iam_group.grupo_admin.name]
}

# Criar arquivo CSV com as credenciais
resource "local_file" "credenciais_csv" {
  filename = var.arquivo_credenciais_nome
  content  = <<-EOF
url: https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console
Usuário: ${aws_iam_user.novo_usuario.name}
Senha: ${aws_iam_user_login_profile.perfil_login.password}
ID: ${data.aws_caller_identity.current.account_id}
  EOF
}

# Output para exibir uma mensagem sobre as credenciais
output "mensagem_credenciais" {
  value = "As credenciais foram salvas no arquivo '${var.arquivo_credenciais_nome}'. A senha deve ser alterada no primeiro login."
}