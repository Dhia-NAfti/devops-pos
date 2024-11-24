node {
    stage('Pull from github  '){
        git 'https://github.com/Dhia-NAfti/devops-pos.git'
    }
     
    stage('Copy Config files from Jenkins Server to Ansible & KBS Servers  '){
        
        sh ''' 
         ssh anibledocker@ansible "mkdir -p /home/anibledocker/config-ansible"
         scp /var/lib/jenkins/workspace/devops-pos-pp/Dockerfile.backend \
            /var/lib/jenkins/workspace/devops-pos-pp/Dockerfile.frontend \
            /var/lib/jenkins/workspace/devops-pos-pp/ansible.yml \
            /var/lib/jenkins/workspace/devops-pos-pp/inventory \
            /var/lib/jenkins/workspace/devops-pos-pp/Frontend-Deployment.yml \
           /var/lib/jenkins/workspace/devops-pos-pp/Frontend-Service.yml \
            anibledocker@ansible:/home/anibledocker/config-ansible
        '''

        sh ''' 
        ssh user@controller "mkdir -p /home/user/config-kbs"
        scp /var/lib/jenkins/workspace/devops-pos-pp/Deployment.yml  /var/lib/jenkins/workspace/devops-pos-pp/Service.yml  user@controller:/home/user/config-kbs 
        '''
     }   
     
     stage('Create Docker Image With Tag for pos-front-end') {
     withCredentials([string(credentialsId: 'github_tocken', variable: 'GITHUB_TOKEN')]) {
        sh """
        ssh anibledocker@ansible "
            cd /home/anibledocker/config-ansible &&
            docker image build -f Dockerfile.frontend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-frontend:v1.${BUILD_ID} . &&
            docker image build -f Dockerfile.frontend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-frontend:latest .
        "
        """
     }
    }
    
    
     stage('Push Image pos-front-end to The Docker Hub') {
    withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
        sh """
        ssh anibledocker@ansible "
            
             echo ${dockerhub_password} | docker login -u dhiaf10 --password-stdin &&
             docker image push dhiaf10/${JOB_NAME}-frontend:v1.${BUILD_ID} &&
             docker image push dhiaf10/${JOB_NAME}-frontend:latest
        "
        """
    }
    
     stage('Docker Logout & Remove Images from Local After Pushing to Docker Hub') {
         sh 'ssh anibledocker@ansible docker image prune -af '
         sh 'ssh anibledocker@ansible docker logout '

    }
}
   
   /* 
   stage('Create Docker Image With Tag for pos-front-end') {
     withCredentials([string(credentialsId: 'github_tocken', variable: 'GITHUB_TOKEN')]) {
        sh """
        ssh anibledocker@ansible "
            cd /home/anibledocker/config-ansible &&
            docker image build -f Dockerfile.frontend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-frontend:v1.${BUILD_ID} . &&
            docker image build -f Dockerfile.frontend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-frontend:latest .
        "
        """
     }
    }
   
   stage('Create Docker Image With Tag for pos-back-end') {
     withCredentials([string(credentialsId: 'github_tocken', variable: 'GITHUB_TOKEN')]) {
        sh """
        ssh anibledocker@ansible "
            cd /home/anibledocker/config-ansible &&
            
            docker image build -f Dockerfile.backend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-backend:v1.${BUILD_ID} . &&
            docker image build -f Dockerfile.backend --build-arg ght=${GITHUB_TOKEN} -t dhiaf10/${JOB_NAME}-backend:latest .
        "
        """
     }
    }
  
   
   stage('Push Image pos-back-end to The Docker Hub') {
    withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
        sh """
        ssh anibledocker@ansible "
            
            echo ${dockerhub_password} | docker login -u dhiaf10 --password-stdin &&
            docker image push dhiaf10/${JOB_NAME}-backend:v1.${BUILD_ID} &&
            docker image push dhiaf10/${JOB_NAME}-backend:latest
                
        "
        """
    }
}

  stage('Docker Logout & Remove Images from Local After Pushing to Docker Hub') {
         sh 'ssh anibledocker@ansible docker image prune -af '
         sh 'ssh anibledocker@ansible docker logout '

    }
   
   
   stage('Execute KBS from Ansible ') {
    sh '''
        ssh anibledocker@ansible "
            cd /home/anibledocker/config-ansible &&
            ansible-playbook -i inventory ansible.yml --extra-vars='ansible_become_pass=user'
        "
    '''
   }
      
}
