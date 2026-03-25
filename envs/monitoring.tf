/************************************************************
Agent Configurations
************************************************************/
### Linux
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

### Windows
resource "oci_logging_unified_agent_configuration" "windows" {
  is_enabled     = true
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "windowsserver-config"
  description    = "For Windows Server Instance"
  group_association {
    group_list = [
      oci_identity_dynamic_group.compute_windows.id
    ]
  }
  service_configuration {
    configuration_type = "MONITORING"
    application_configurations {
      source_type = "URL"
      source {
        name = "url-source"
        scrape_targets {
          name = "prometheus-windows-exporter"
          url  = "http://localhost:9182/metrics"
        }
      }
      destination {
        compartment_id    = oci_identity_compartment.workload.id
        metrics_namespace = "custom_metrics_namespace_windowsserver"
      }

      unified_agent_configuration_filter {
        filter_type = "URL_FILTER"
        name        = "windows-exporter-metrics-filter-regex"
        allow_list = [
          "windows_memory_available_bytes",
          "windows_logical_disk_free_bytes",
          "windows_service_state"
        ]
        # # 空で書いてもすべてにマッチする条件が書かれた<exclude>セクションが作成されてしまうため注意
        # deny_list   = []
      }
    }
  }
  defined_tags = local.common_defined_tags
}