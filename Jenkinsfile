pipeline { 
    agent none 
    stages { 
        stage('Checkout') { 
            agent { label 'buildup-babai' } 
            steps { 
                echo 'Checking out source code...' 
                git branch: 'main', url: 'https://github.com/rajeshnagarikanti9/currency-converter.git' 
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
                // FIXED: Lowercase name matches your Jenkins System configuration
                withSonarQubeEnv('sonarqube-server') { 
                    echo 'Running SonarQube Code Analysis...'
                    // Maven automatically detects the token and server URL injected by withSonarQubeEnv
                    sh "mvn sonar:sonar -Dsonar.projectKey=currency-converter"
                }
            }
        }

        stage('Quality Gate') {
            agent { label 'buildup-babai' }
            steps {
                echo 'Checking SonarQube Quality Gate Status...'
                // Pauses pipeline for up to 10 mins waiting for SonarQube results
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Archive Artifact') { 
            agent { label 'buildup-babai' } 
            steps { 
                echo 'Archiving WAR artifact...' 
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true 
                echo 'Storing WAR for deployment...' 
                stash name: 'application-war', includes: 'target/*.war' 
            } 
        } 
        
        stage('Deploy') { 
            agent { label 'test-node' } 
            steps { 
                echo 'Preparing deployment...' 
                unstash 'application-war' 
                sh ''' 
                echo "Removing old WAR files..." 
                rm -rf /home/ubuntu/tomcat9/webapps/*.war 
                echo "Renaming WAR..." 
                mv target/*.war target/ROOT.war 
                echo "Copying WAR to Tomcat..." 
                cp target/ROOT.war /home/ubuntu/tomcat9/webapps/ 
                echo "Deployment completed successfully!" 
                ''' 
            } 
        } 
    } 
    post { 
        success { 
            echo '======================================' 
            echo 'BUILD SUCCESSFUL' 
            echo 'ARTIFACT ARCHIVED' 
            echo 'DEPLOYMENT SUCCESSFUL' 
            echo '=====================================' 
        } 
        failure { 
            echo '======================================' 
            echo 'PIPELINE FAILED' 
            echo 'Check the console output for details.' 
            echo '======================================' 
        } 
    } 
}
