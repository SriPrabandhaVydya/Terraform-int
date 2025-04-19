pipeline {
    agent any

    environment {
        TF_VAR_bucket_name = 'sri-demo-bucket-12345'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    options {
        skipStagesAfterUnstable()
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh 'terraform init'
            }
        }

        stage('Terraform Format Check') {
            steps {
                echo "Checking Terraform format..."
                sh 'terraform fmt -recursive'
'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Running Terraform plan..."
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            input {
                message "Apply Terraform plan?"
                ok "Apply"
            }
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply tfplan'
            }
        }

        // Optional destroy stage - only if needed
        // stage('Terraform Destroy') {
        //     input {
        //         message "Do you want to destroy the infrastructure?"
        //         ok "Destroy"
        //     }
        //     steps {
        //         echo "Destroying infrastructure..."
        //         sh 'terraform destroy -auto-approve'
        //     }
        // }
    }

    post {
        success {
            echo "Terraform deployment completed successfully!"
        }
        failure {
            echo "Terraform deployment failed."
        }
        always {
            echo "Cleaning up Terraform plan file..."
            sh 'rm -f tfplan || true'
        }
    }
}
