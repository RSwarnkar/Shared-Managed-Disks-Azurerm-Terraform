
# Create RG for vnet:
$vnet_rg_name = "rg-vnet-$(-join ((97..122) | Get-Random -Count 4 | % {[char]$_}))"
New-AzResourceGroup -Name  $vnet_rg_name -Location "East US"

# Create 2 Subnets : 
$subnet01 = New-AzVirtualNetworkSubnetConfig -Name "subnet-01" -AddressPrefix "10.100.0.0/24"

$subnet02 = New-AzVirtualNetworkSubnetConfig -Name "subnet-02" -AddressPrefix "10.100.1.0/24"
 
New-AzVirtualNetwork -Name "vnet-01" -ResourceGroupName $vnet_rg_name -Location "East US" -AddressPrefix "10.100.0.0/16" -Subnet $subnet01,$subnet02


New-AzNetworkSecurityGroup -Name "subnet-01-nsg" -ResourceGroupName $vnet_rg_name  -Location "East US"

New-AzNetworkSecurityGroup -Name "subnet-02-nsg" -ResourceGroupName $vnet_rg_name  -Location "East US"


## Attach NSGs to Subnets : 

$virtualNetwork = Get-AzVirtualNetwork -Name "vnet-01" -ResourceGroupName $vnet_rg_name

 
$networkSecurityGroup1 = Get-AzNetworkSecurityGroup -Name "subnet-01-nsg" -ResourceGroupName $vnet_rg_name

$networkSecurityGroup2 = Get-AzNetworkSecurityGroup -Name "subnet-02-nsg" -ResourceGroupName $vnet_rg_name

 
Set-AzVirtualNetworkSubnetConfig -Name "subnet-01" -VirtualNetwork $virtualNetwork  -NetworkSecurityGroup $networkSecurityGroup1 -AddressPrefix "10.100.0.0/24"

Set-AzVirtualNetworkSubnetConfig -Name "subnet-02" -VirtualNetwork $virtualNetwork  -NetworkSecurityGroup $networkSecurityGroup2 -AddressPrefix "10.100.1.0/24"

Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork


## Add NSG Rules to NSGs to allow SSH and RDP for VMs:

## NSG 1
$RG_NAME     = $vnet_rg_name
$NSG_NAME    = "subnet-01-nsg"
$RULE_NAME   = "SR-AllowRdpSsh-Inbound"
$ACCESS_TYPE = "Allow"
$PROTOCOL    = "*" # TCP, UDP, * 
$DIRECTION   = "Inbound" # Inbound, Outbound
$PRIORITY    = "4000" # Starts with 3001
$SRC_IPS     = ("*") # List of IPs or CIDR or *
$SRC_PORTS   = ("*") # List of Port number or *
$DEST_IPS    = ("10.100.0.0/16") # # List of IPs or CIDR or *
$DEST_PORTS  = ("3389", "22") # List of Port number or *

## Add NEW 
Get-AzNetworkSecurityGroup -ResourceGroupName $RG_NAME -Name $NSG_NAME | Add-AzNetworkSecurityRuleConfig -Name $RULE_NAME -Access $ACCESS_TYPE -Protocol $PROTOCOL -Direction $DIRECTION -Priority $PRIORITY -SourceAddressPrefix $SRC_IPS -SourcePortRange $SRC_PORTS -DestinationAddressPrefix $DEST_IPS -DestinationPortRange $DEST_PORTS | Set-AzNetworkSecurityGroup

## NSG 2
$RG_NAME     = $vnet_rg_name
$NSG_NAME    = "subnet-02-nsg"
$RULE_NAME   = "SR-AllowRdpSsh-Inbound"
$ACCESS_TYPE = "Allow"
$PROTOCOL    = "*" # TCP, UDP, * 
$DIRECTION   = "Inbound" # Inbound, Outbound
$PRIORITY    = "4000" # Starts with 3001
$SRC_IPS     = ("*") # List of IPs or CIDR or *
$SRC_PORTS   = ("*") # List of Port number or *
$DEST_IPS    = ("10.100.0.0/16") # # List of IPs or CIDR or *
$DEST_PORTS  = ("3389", "22") # List of Port number or *

## Add NEW 
Get-AzNetworkSecurityGroup -ResourceGroupName $RG_NAME -Name $NSG_NAME | Add-AzNetworkSecurityRuleConfig -Name $RULE_NAME -Access $ACCESS_TYPE -Protocol $PROTOCOL -Direction $DIRECTION -Priority $PRIORITY -SourceAddressPrefix $SRC_IPS -SourcePortRange $SRC_PORTS -DestinationAddressPrefix $DEST_IPS -DestinationPortRange $DEST_PORTS | Set-AzNetworkSecurityGroup