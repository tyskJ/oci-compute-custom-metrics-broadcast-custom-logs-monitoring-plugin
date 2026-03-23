/************************************************************
Common
************************************************************/
locals {
  common_defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag.key_env.name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag.key_managedbyterraform.name) = "true"
  }
}