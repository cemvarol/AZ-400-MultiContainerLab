# Get Login Name
a=$(az ad signed-in-user show --query userPrincipalName)
# Get change Login Name to lower-case
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
# Create Variables
C=${B:: -24}
AksName=$(echo "$C"aksc01)
AcrName=$(echo "$C"acr01)
DbSrv=$(echo "$C"aksdbs01)
RG=akshandsonlab
L=westus
user=sqladmin
pass=1q2w3e4r5t6y*

version=$(az aks get-versions -l $L --query 'orchestrators[-1].orchestratorVersion' -o tsv)

az group create --name $RG --location $L

az aks create --resource-group $RG --name $AksName --enable-addons monitoring --kubernetes-version $version --generate-ssh-keys --location $L


az acr create --resource-group $RG --name $AcrName --sku Standard --location $L


AKS_RESOURCE_GROUP=$(echo "$RG")
AKS_CLUSTER_NAME=$(echo "$AksName")
ACR_RESOURCE_GROUP=$(echo "$RG")
ACR_NAME=$(echo "$AcrName")


az ad sp create-for-rbac -n msi

sp=msi

az ad sp list --filter "displayName eq '$sp'" --query '[].{appId:appId}' -o tsv

#CLIENT_ID=$(az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

CLIENT_ID=$(az ad sp list --filter "displayName eq '$sp'" --query '[].{appId:appId}' -o tsv)

ACR_ID=$(az acr show --name $ACR_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)

az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

az sql server create -l eastus -g $AKS_RESOURCE_GROUP -n $DbSrv -u $user -p $pass

az sql db create -g $AKS_RESOURCE_GROUP -s $DbSrv -n mhcdb --service-objective S0


az aks update -n $AksName -g $RG --attach-acr $AcrName

#


echo -e "\nPlease take a note of these \nYour Resource Group Name is $RG \nYour ACR name is "$AcrName".azurecr.io \nYour Sql user name is $user \nYour Sql Password is $pass \nYour Sql Server name is $DbSrv.database.windows.net \nYour Database name is mhcdb \nYour AKSname is $AksName\n"



#
