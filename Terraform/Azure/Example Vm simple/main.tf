#resource group creation
####################################################################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}rg"
  location = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



#######################################################################
# azurerm_subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "ubuntusgassociation" {
  subnet_id                 = azurerm_subnet.subnetUB.id
  network_security_group_id = azurerm_network_security_group.nsgUB.id
}

#resource "azurerm_subnet_network_security_group_association" "centossgassociation" {
#  subnet_id                 = azurerm_subnet.subnetcentos.id
#  network_security_group_id = azurerm_network_security_group.subnetcentossg.id
#}

######################################################
#UBUNTU
# Create public IPs
resource "azurerm_public_ip" "publicipUB" {
  name                = "${var.prefix}PublicIPUB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create subnet
resource "azurerm_subnet" "subnetUB" {
  name                 = "${var.prefix}mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Security Group and rule
# Security group UB
resource "azurerm_network_security_group" "nsgUB" {
  name                = "${var.prefix}nsgUB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "tcp22"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "tcp80"
    priority                   = 2200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "tcp443"
    priority                   = 2400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  #OUTBOUND RULES 
  security_rule {
    name                       = "InternetAccess"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*" 
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nicUB" {
  name                = "${var.prefix}NicUB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.prefix}NicConfiguration"
    subnet_id                     = azurerm_subnet.subnetUB.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicipUB.id
  }
}


# Ubuntu VM creation
resource "azurerm_virtual_machine" "vmUB" {
  name                  = "${var.prefix}vmubuntu"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nicUB.id]
  vm_size               = "Standard_B1s"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.prefix}osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = var.pasubuntu
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

##azurerm_virtual_machine_extension
#resource "azurerm_virtual_machine_extension" "vmext" {
#  name                 = "${var.prefix}vmext"
#  virtual_machine_id   = azurerm_virtual_machine.vmUB.id
#  publisher            = "Microsoft.Azure.Extensions"
#  type                 = "CustomScript"
#  type_handler_version = "2.1"
#
#  protected_settings = <<PROT
#    {
#        "script": "${base64encode(file("script.sh"))}"
#    }
#    PROT
#}