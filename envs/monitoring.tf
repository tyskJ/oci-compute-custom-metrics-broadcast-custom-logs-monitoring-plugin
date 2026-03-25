/************************************************************
Agent Configurations
************************************************************/
resource "oci_logging_unified_agent_configuration" "oracle" {
  is_enabled     = true
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "oracle-config"
  description    = "For Oracle Linux Instance"
  group_association {
    group_list = [
      oci_identity_dynamic_group.compute_oracle.id
    ]
  }
  service_configuration {
    configuration_type = "MONITORING"
    application_configurations {
      source_type = "URL"
      source {
        name = "url-source"
        scrape_targets {
          name = "prometheus-node-exporter"
          url  = "http://localhost:9100/metrics"
        }
      }
      destination {
        compartment_id    = oci_identity_compartment.workload.id
        metrics_namespace = "custom_metrics_namespace_oraclelinux"
      }
      unified_agent_configuration_filter {
        filter_type = "URL_FILTER"
        name        = "node-exporter-metrics-filter-regex"
        allow_list = [
          "node_memory_MemFree_bytes",
          "node_memory_SwapFree_bytes",
          "node_filesystem_free_bytes",
          "node_systemd_unit_state"
        ]
        # # 空で書いてもすべてにマッチする条件が書かれた<exclude>セクションが作成されてしまうため注意
        # deny_list   = []
      }
    }
  }
  defined_tags = local.common_defined_tags
}