locals {
  language_default = {
    nodejs = {
      runtime       = ["18", "16", "14", "12"]
      source_folder = "./sample-code/nodejs"
    },
    python = {
      runtime       = ["3.11", "3.10", "3.9", "3.8", "3.7", "3.6"]
      source_folder = "./sample-code/python"
    },
    java = {
      runtime       = ["java17", "java11", "java8"]
      source_folder = "./sample-code/java"
    }
  }
}

locals {
  function_language        = local.language_default["${var.function_language}"]
  function_runtime_version = contains(local.function_language.runtime, var.function_runtime_version) ? var.function_runtime_version : local.function_language.runtime[0]
  source_code_folder       = (var.source_code_folder == null) ? local.function_language.source_folder : var.source_code_folder
  function_description     = "This Scheduled Job written in ${local.function_runtime_version} and running on a schedule mentioned in the function.json"
}

data "archive_file" "function_package" {
  type        = "zip"
  source_dir  = "${local.source_code_folder}/"
  output_path = "${var.function_app_name}-pkg.zip"
}

resource "azurerm_storage_account" "example" {
  # used regex to convert to lowercase and keep only alphanumeric
  name                     = "${lower(replace(var.function_app_name, "/\\W|_|\\s/", ""))}store"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "example" {
  name                = "${var.function_app_name}-appinsights"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
}

resource "azurerm_service_plan" "example" {
  name                = "${var.function_app_name}-sp"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "Y1"
}

resource "azurerm_linux_function_app" "example" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  zip_deploy_file = data.archive_file.function_package.output_path

  site_config {
    application_stack {
      python_version = (var.function_language == "python") ? local.function_runtime_version : null
      node_version   = (var.function_language == "nodejs") ? local.function_runtime_version : null
    }
    application_insights_connection_string = azurerm_application_insights.example.connection_string
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = 1
  }

  tags = var.tags
}

