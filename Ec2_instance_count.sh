for Region in $(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d '"'); do
    #echo "Checking instance details in the region: $Region "
    #Instance_Region=$(sed -e 's/-/_/g' <<<"${Region}")
    #echo "${Instance_Region}"
    Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d '"' | wc -l)
    if [ $Inscount -ne 0 ]; then
        echo "Checking instance details in the region: $Region "
        echo "================================================="
        echo -e " Total Instance available in the region:$Region and count as: $Inscount\n"
        echo "$Inscount" >count_instance.log
        cat count_instance.log
        aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d '"'
    fi
done
