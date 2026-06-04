pipeline {
    agent any


     tools { 
        maven 'maven3' 
    }
	
	stages {
	
    stage('Checkout') { 
            steps { 
                echo 'Cloning GIT HUB Repo' 
                // Clone the specified branch from the GitHub repository 
                git branch: 'main', url: 'https://github.com/tecnomc/CICD-End-to-End.git'
            }   
        } 
	
	
      stage('SonarQube Scan') {
      steps {
             echo 'Scanning project'
            sh 'ls -ltr'
        
        sh '''
            mvn sonar:sonar \
                -Dsonar.host.url=http://44.204.197.247:9000 \
                -Dsonar.login=squ_58ae7fcc1a0f10a97e16b9b2af970be58c515c44
        '''
         }
       }
	
        stage('Build Artifact') { 
            steps { 
                echo 'Build Artifact' 
                sh 'mvn clean package' 
            } 
        } 
	
	
	
      stage('Build Docker Image') { 
            steps { 
                echo 'Build Docker Image' 
                // Build the Docker image using the Dockerfile in the project 
                // Tag the image with the current build number 
                sh 'docker build -t shilpa1819/cicd:${BUILD_NUMBER} -f Dockerfile .' 
            } 
        } 
	
	stage('Scan Docker Image using Trivy') { 
            steps { 
                echo 'scanning Image' 
               
               
                sh 'trivy image shilpa1819/cicd:${BUILD_NUMBER}' 
            } 
        } 
	
	
	  stage('Push to Docker Hub') { 
            steps { 
                script { 
                 
                  	withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                         sh 'docker login -u shilpa1819 -p ${dockerhub}' 
	
                      }
                    // Push the Docker image to Docker Hub 
                    sh 'docker push shilpa1819/cicd:${BUILD_NUMBER}' 
                    echo 'Pushed to Docker Hub' 
                } 
            } 
        } 
	
	

	stage('Update Deployment File') { 
            environment { 
                GIT_REPO_NAME = "CICD-End-to-End" 
                GIT_USER_NAME = "tecnomc" 
            } 
            steps { 
                echo 'Update Deployment File' 
				
				withCredentials([string(credentialsId: 'githubtoken', variable: 'githubtoken')]) {
    // some block
}
              
                withCredentials([string(credentialsId: 'githubtoken', variable: 'githubtoken')]) { 
                    sh ''' 
                        # Configure git user 
                        git config user.email "shilpa123@gmail.com" 
                        git config user.name "Shilpa" 
						
                        # Replace the tag in the deployment YAML file with the current buil  number 						
                        sed -i "s/cicd:.*/cicd:${BUILD_NUMBER}/g" deploymentfiles/deployment.yaml 
						
						
                        #Stage all changes 

                        git add . 
                        # Commit changes with a message containing the build number 
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}" 
                        #Push changes to the main branch of the GitHub repository 
                        git push https://${githubtoken}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main ''' 
                } 
            } 
        } 
         
    } 
}
