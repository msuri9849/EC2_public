sh '''#!/bin/bash
#set -x

for Region in $(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d \'"\'); do
    #echo "Checking instance details in the region: $Region "
    #Instance_Region=$(sed -e \'s/-/_/g\' <<<"${Region}")
    #echo "${Instance_Region}"
    Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\' | wc -l)
    if [ $Inscount -ne 0 ]; then
        echo "Checking instance details in the region: $Region "
        echo "================================================="
        echo -e " Total Instance available in region:$Region as $Inscount\\n"
        aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d \'"\'
    fi
done
'''
