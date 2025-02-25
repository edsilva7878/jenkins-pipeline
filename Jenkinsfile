pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"
        // Pega as credenciais configuradas no Jenkins
        AWS_ACCESS_KEY_ID = credentials('aws-credentials') // AWS Access Key ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials') // AWS Secret Access Key
    }
    stages {
        stage('Init') {
            steps {
                script {
                    echo 'Iniciando job init....'
                    sh 'terraform init -reconfigure'
                    echo 'Terraform inicializado com sucesso!'
                    echo 'Job init concluído'
                }
            }
        }
        stage('Validate') {
            steps {
                script {
                    echo 'Iniciando validate'
                    sh 'terraform validate'
                    echo 'Validate concluído'
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                    echo 'Iniciando plan'
                    sh 'terraform plan -out=plan.out'
                    echo 'Plan concluído'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'plan.out', allowEmptyArchive: true
                }
            }
        }
        stage('Apply') {
            steps {
                script {
                    echo 'Iniciando apply'
                    sh 'terraform apply -auto-approve plan.out'
                    echo 'Apply concluído'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'terraform.tfstate', allowEmptyArchive: true
                    // Arquivar o arquivo CSV de credenciais gerado pelo Terraform
                    archiveArtifacts artifacts: 'credentials.csv', allowEmptyArchive: true
                }
            }
        }
        stage('Destroy') {
            steps {
                script {
                    echo 'Iniciando destroy'
                    sh 'terraform destroy -auto-approve'
                    echo 'Destroy concluído'
                }
            }
            when {
                branch 'main'
            }
            options {
                skipDefaultCheckout()
            }
            post {
                always {
                    archiveArtifacts artifacts: 'terraform.tfstate', allowEmptyArchive: true
                }
            }
        }
    }
}
