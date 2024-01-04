variable "resource_group_name" {
  type        = string
  default     = null
  description = "Azure Resource Group name where the function and other resources should be created."
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Location/Region where your function and resources should be deployed."
}

variable "function_app_name" {
  type        = string
  default     = "scheduled-jobs"
  description = "Name of the Function App."
  validation {
    condition     = (length(var.function_app_name) < 21)
    error_message = "Function App name should be less than 20 characters"
  }
}

variable "function_source_code_folder" {
  type        = string
  default     = null
  description = "Folder with all source code files for the scheduled job."
}

variable "function_language" {
  type        = string
  default     = "nodejs"
  description = "Language of the code written for scheduled job.  All supported langauges are listed in README."
  validation {
    condition     = contains(["nodejs", "python"], var.function_language)
    error_message = "Unsupported Language <${var.function_language}>. Supported values are <nodejs, Python>"
  }
}

variable "function_runtime_version" {
  type        = string
  default     = "18"
  description = "Runtime identifier based on the language and version the scheduled-job code is written.  All supported runtimes are listed in README."
  validation {
    condition     = contains(["18", "16", "14", "12", "3.11", "3.10", "3.9", "3.8", "3.7", "3.6", null], var.function_runtime_version)
    error_message = "Unsupported runtime version <${var.function_runtime_version}>"
  }
}

variable "tags" {
  type        = map(any)
  description = "List of Tags for the function."
  default = {
    "created_by" : "Terraform-Module: TechieInYou/scheduled-job/azure"
  }
}
