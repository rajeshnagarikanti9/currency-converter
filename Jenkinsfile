pipeline {
    agent none

    stages {

        stage('Checkout') {
            agent { label 'buildup-babai' }

            steps {
                echo 'Checking out source code...'

                git branch: 'main',
                    url: 'https://github.com/rajeshnagarikanti9/currency-converter.git'
            }
        }

        stage('Build') {
            agent { label 'buildup-babai' }

            steps {
                echo 'Building application with Maven...'

                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            agent { label 'buildup-babai' }

            steps {
                withSonarQubeEnv('sonarqube-server') {

                    withCredentials([
                        string(
                            credentialsId: 'sonar',
                            variable: 'SONAR_TOKEN'
                        )
                    ]) {

                        echo 'Running SonarQube Code Analysis...'

                        sh '''
                            mvn org.sonarsource.scanner.maven:sonar-maven-plugin:5.7.0.6970:sonar \
                                -Dsonar.projectKey=currency-converter \
                                -Dsonar.token="$SONAR_TOKEN"
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            agent { label 'buildup-babai' }

            steps {
                echo 'Checking SonarQube Quality Gate Status...'

                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Archive Artifact') {
            agent { label 'buildup-babai' }

            steps {
                echo 'Archiving WAR artifact...'

                archiveArtifacts artifacts: 'target/*.war',
                                 fingerprint: true

                echo 'Storing WAR for deployment...'

                stash name: 'application-war',
                      includes: 'target/*.war'
            }
        }

        stage('Deploy') {
            agent { label 'test-node' }

            options {
                skipDefaultCheckout()
            }

            steps {
                echo 'Cleaning deployment workspace...'

                deleteDir()

                echo 'Getting WAR artifact from build server...'

                unstash 'application-war'

                sh '''
                    echo "WAR file received from build server:"
                    ls -lh target/*.war

                    echo "Removing old WAR files from Tomcat..."

                    rm -f /home/ubuntu/tomcat9/webapps/*.war
                    rm -rf /home/ubuntu/tomcat9/webapps/ROOT

                    echo "Renaming WAR to ROOT.war..."

                    mv target/*.war target/ROOT.war

                    echo "Deploying application to Tomcat..."

                    cp target/ROOT.war /home/ubuntu/tomcat9/webapps/

                    echo "======================================"
                    echo "DEPLOYMENT SUCCESSFUL"
                    echo "======================================"

                    echo "Deployed WAR:"
                    ls -lh /home/ubuntu/tomcat9/webapps/ROOT.war
                '''
            }
        }
    }

    post {

        success {
            echo '======================================'
            echo 'BUILD SUCCESSFUL'
            echo 'SONARQUBE ANALYSIS SUCCESSFUL'
            echo 'QUALITY GATE PASSED'
            echo 'ARTIFACT ARCHIVED'
            echo 'DEPLOYMENT SUCCESSFUL'
            echo '======================================'
        }

        failure {
            echo '======================================'
            echo 'PIPELINE FAILED'
            echo 'Check the console output for details.'
            echo '======================================'
        }
    }
}
