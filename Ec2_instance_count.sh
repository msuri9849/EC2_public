rm -rf EC2_public/
git clone -b testing git@github.com:msuri9849/EC2_public.git
Count_ins=$(cat EC2_public.git/Inscount_count_ap-southeast-1)
for Region in $(aws ec2 describe-regions | jq ".Regions[].RegionName" | tr -d '"'); do
       Inscount=$(aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d '"' | wc -l)
	    if [[ $Inscount -ne 0 ]]; then
		if [[ $Count_ins -eq  $Inscount ]];then
		echo " There was no change in instance count"
		else
		cd EC2_public
        echo "$Inscount" >Inscount_count_${Region}
		git add . && git commit -m "Instance count changed"
		git push origin
		cd ..
        echo "Checking instance details in the region: $Region "
        echo "================================================="
        echo -e " Total Instance available in the region:$Region and count as: $Inscount\n"
        aws ec2 describe-instances --region "$Region" | jq ".Reservations[].Instances[].InstanceId" | tr -d '"'
        echo " "
		fi
    fi
done
