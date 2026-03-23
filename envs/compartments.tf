/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "oci-compute-custom-metrics-broadcast-custom-logs-monitoring-plugin"
  description    = "For OCI Compute Custom Metrics Broadcast Custom Logs Monitoring Plugin"
  enable_delete  = true
}