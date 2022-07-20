terraform {
  required_providers {
    oci = {
        source = "hashicorp/oci"
    }
  }
}

provider "oci" {
    region = var.region
  
}

resource "oci_core_vcn" "tf_demo_vcn" {
  dns_label = var.vcn_dns_label
  cidr_block = var.vcn_cidr_block
  compartment_id = var.vcn_compartment_id
  display_name = var.vcn_display_name
}

resource "oci_core_subnet" "tf_demo_subnet" {
  vcn_id = oci_core_vcn.tf_demo_vcn.id
  cidr_block = var.subnet_cidr_block
  compartment_id = var.subnet_compartment_id
  display_name = var.subnet_display_name
  prohibit_public_ip_on_vnic = false
  dns_label = var.subnet_dns_label
}

resource "oci_core_instance" "tf_demo_instance" {
  availability_domain = var.availability_domain
  compartment_id = var.vcn_compartment_id
  display_name = var.vm_display_name
  shape = var.vm_shape_name

  create_vnic_details {
    subnet_id = oci_core_subnet.tf_demo_subnet.id
    assign_public_ip = "False"
  }

source_details {
  source_type = "image"
  source_id = var.vm_image_id
}

}