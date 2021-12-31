pipeline{
    agent {
        label any
     }
     environment {
	GIT_TOKEN   = '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'
	GIT_LOC     = 'msuri9849'
	GIT_BRANCH = 'testing'
     }
	 stages{
     stage('Git_Repoclone'){
	    steps{
		sh '''
		git clone -b ${GIT_BRANCH} https://${GIT_TOKEN}@github.com/${GIT_LOC}/EC2_public.git /tmp/EC2_public.git
		'''
	     }
	 }
	 stage('Ec2_count') {
            steps {
                withAWS(credentials: '9cc1463e-6592-48a0-bc73-350382a29c98', region: 'ap-southeast-1') {
                sh '''for Region in $(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d \'"\'); do
        Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\' | wc -l)
    if [ $Inscount -ne 0 ]; then
        echo "$Inscount" >/tmp/EC2_public/Inscount_count_${Region}
		cd /tmp/EC2_public/
        git status
        git init
        git add .
        git commit -m "Commiting for region"
        git push -u origion testing 
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
