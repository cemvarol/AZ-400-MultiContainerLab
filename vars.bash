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

AKS_RESOURCE_GROUP=$(echo "$RG")
AKS_CLUSTER_NAME=$(echo "$AksName")
ACR_RESOURCE_GROUP=$(echo "$RG")
ACR_NAME=$(echo "$AcrName")

#

clear

echo -e "\nPlease take a note of these \nYour Resource Group Name is $RG \nYour ACR name is "$AcrName".azurecr.io \nYour Sql user name is $user \nYour Sql Password is $pass \nYour Sql Server name is $DbSrv.database.windows.net \nYour Database name is mhcdb \nYour AKSname is $AksName\n"



#
