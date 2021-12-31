pipeline {
    agent any

    stages {
        stage('AWS Credentials') {
            steps {
                withAWS(credentials: '9cc1463e-6592-48a0-bc73-350382a29c98', region: 'ap-southeast-1') {
                    sh 'echo "Hellow Jenkins"'
                }
            }
        }
        stage('Ec2_count') {
            steps {
                withAWS(credentials: '9cc1463e-6592-48a0-bc73-350382a29c98', region: 'ap-southeast-1') {
                    sh '''Region_List=$(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d \'"\')
                    for Region in $(Region_List); do
    #echo "Checking instance details in the region: $Region "
    #Instance_Region=$(sed -e \'s/-/_/g\' <<<"${Region}")
    #echo "${Instance_Region}"
    Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\' | wc -l)
    if [ $Inscount -ne 0 ]; then
        echo "Checking instance details in the region: $Region "
        echo "================================================="
        echo -e " Total Instance available in the region:$Region and count as: $Inscount\\n"
        echo "$Inscount" >count_instance.log
        aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\'
    fi
done'''
                }
            }
        }
    }
}
