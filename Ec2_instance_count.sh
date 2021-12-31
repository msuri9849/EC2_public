pipeline {
    agent any

    stages {
        stage('Git_CLONE') {
            steps {
                git branch: 'testing', credentialsId: '44c1b9e5-4c23-4204-8852-60752b17a3a0', url: 'https://github.com/msuri9849/EC2_public.git'
                }
            }
        }
        stage('Ec2_count') {
            steps {
                withAWS(credentials: '9cc1463e-6592-48a0-bc73-350382a29c98', region: 'ap-southeast-1') {
                sh '''for Region in $(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d \'"\'); do
    #echo "Checking instance details in the region: $Region "
    #Instance_Region=$(sed -e \'s/-/_/g\' <<<"${Region}")
    #echo "${Instance_Region}"
    Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\' | wc -l)
    if [ $Inscount -ne 0 ]; then
        echo "$Inscount" >Inscount_count_${Region}
        git add .
        git commit -m "Commiting for region"
        git push -u origion testing https://github.com/msuri9849/EC2_public.git
        echo "Checking instance details in the region: $Region "
        echo "================================================="
        echo -e " Total Instance available in the region:$Region and count as: $Inscount\\n"
        aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\'
        echo " "

    fi
done'''
                }
            }
        }
    }
}
