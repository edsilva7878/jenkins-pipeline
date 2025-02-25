pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.6.6'
            args '-v $HOME/.aws:/root/.aws'
        }
    }
    
    environment {
        AWS_REGION = 'us-east-1'
        AWS_CREDENTIALS = credentials('aws-credentials')
    }
    
    stages {
        stage('Setup') {
            steps {
                sh '''
                    apk add --no-cache aws-cli
                    mkdir -p ~/.aws
                    
                    cat > ~/.aws/credentials << EOF
                    [default]
                    aws_access_key_id=${AWS_CREDENTIALS_USR}
                    aws_secret_access_key=${AWS_CREDENTIALS_PSW}
                    EOF
                    
                    cat > ~/.aws/config << EOF
                    [default]
                    region = ${AWS_REGION}
                    EOF
                    
                    aws sts get-caller-identity
                    terraform --version
                '''
            }
        }
        
        stage('Init') {
            steps {
                echo 'Iniciando job init....'
                sh 'terraform init -reconfigure'
                echo 'Terraform inicializado com sucesso!'
                echo 'Job init concluído'
            }
        }
        
        stage('Validate') {
            steps {
                echo 'Iniciando validate'
                sh 'terraform validate'
                echo 'Validate concluído'
            }
        }
        
        stage('Plan') {
            steps {
                echo 'Iniciando plan'
                sh 'terraform plan -out=plan.out'
                echo 'Plan concluído'
                stash includes: 'plan.out', name: 'plan'
            }
        }
        
        stage('Apply') {
            when {
                branch 'main'
            }
            steps {
                echo 'Iniciando apply'
                unstash 'plan'
                sh 'terraform apply -auto-approve plan.out'
                echo 'Apply concluído'
                archiveArtifacts artifacts: 'terraform.tfstate', fingerprint: true
            }
        }
        
        stage('Destroy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Iniciando destroy'
                sh 'ls -lah'
                input message: 'Deseja destruir a infraestrutura?', ok: 'Sim, destruir'
                sh 'terraform destroy -auto-approve'
                echo 'Destroy concluído'
                archiveArtifacts artifacts: 'terraform.tfstate', fingerprint: true
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
