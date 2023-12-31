locals {
  language_default = {
    nodejs = {
      runtime     = ["nodejs20.x", "nodejs18.x", "nodejs16.x"]
      source_file = "./sample-code/nodejs/index.js"
      handler     = "index.handler"
    },
    python = {
      runtime     = ["python3.12", "python3.11", "python3.10", "python3.9", "python3.8"]
      source_file = "./sample-code/python/__init__.py"
      handler     = "function.handler"
    },
    java = {
      runtime     = ["java17", "java11", "java8"]
      source_file = "./sample-code/java/Handler.java"
      handler     = "example.Handler::handleRequest"
    }
  }
}

locals {
  function_language = local.language_default["${var.function_language}"]
  function_runtime  = contains(local.function_language.runtime, var.function_runtime) ? var.function_runtime : local.function_language.runtime[0]
  # function_runtime_check = (var.function_runtime == null) ? local.function_language.runtime[0] : var.function_runtime
  function_source_file = (var.function_source_file == null) ? local.function_language.source_file : var.function_source_file
  function_handler     = (var.function_handler == null) ? local.function_language.handler : var.function_handler
  function_description = "This Scheduled Job written in ${local.function_runtime} and running on a schedule ${var.schedule}"
}

# locals {
#   function_runtime = contains(local.function_language.runtime, local.function_runtime_check) ? local.function_runtime_check : local.function_language.runtime[0]
# }

data "archive_file" "function_package" {
  type        = "zip"
  source_file = local.function_source_file
  output_path = "${var.function_name}-pkg.zip"
}

# resource "azurerm_resource_group" "resource_group" {
#   name = var.resource_group_name
#   location = var.location
# }

resource "azurerm_storage_account" "example" {
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
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "example" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  site_config {
    application_insights_connection_string = azurerm_application_insights.example.connection_string
  }
}

resource "azurerm_function_app_function" "example" {
  name            = var.function_name
  function_app_id = azurerm_linux_function_app.example.id
  language        = var.function_language
  file {
    name    = "__init__.py"
    content = file("./sample-code/python/__init__.py")
  }
  config_json = file("./sample-code/python/function.json")
}


# https://www.maxivanov.io/deploy-azure-functions-with-terraform/
# https://medium.com/@abhimanyubajaj98/deploying-azure-functions-with-terraform-and-visual-studio-code-d7bd6d629aa5
# https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/app-service/function-python/main.tf
