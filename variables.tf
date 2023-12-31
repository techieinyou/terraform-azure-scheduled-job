variable "resource_group_name" {
  type        = string
  default     = null
  description = "Azure Resource name where the function and other resources should be created"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "function_app_name" {
  type        = string
  default     = "scheduled-jobs"
  description = "Name of the Function App."
}

variable "function_name" {
  type        = string
  default     = "scheduled-job1"
  description = "Name of the Function for the scheduled job."
}

variable "function_source_file" {
  type        = string
  default     = null
  description = "File name where the code contains for scheduled job."
}

variable "function_handler" {
  type        = string
  default     = null
  description = "Entry-point function name to start executing the function. Default values are Nodejs: index.handler,  Python: function_function.main."
}

variable "function_language" {
  type        = string
  default     = "nodejs"
  description = "Language of the code written for scheduled job.  All supported langauges are listed in README."
  validation {
    condition     = contains(["nodejs", "python"], var.function_language)
    error_message = "Unsupported Language <${var.function_language}>. Supported values are <nodejs, python>"
  }
}

variable "function_runtime" {
  type        = string
  default     = "nodejs20.x"
  description = "Runtime identifier based on the language and version the scheduled-job code is written. All supported runtimes are listed in README."
  validation {
    condition     = contains(["nodejs20.x", "nodejs18.x", "nodejs16.x", "python3.12", "python3.11", "python3.10", "python3.9", "python3.8", null], var.function_runtime)
    error_message = "Unsupported runtime <${var.function_runtime}>"
  }
}

variable "function_timeout" {
  type        = number
  default     = 180
  description = "Execution Timeout for the function."
}

variable "function_layers" {
  type        = list(string)
  default     = null
  description = "List of function Layers to be used by the scheduled-job function."
}

variable "schedule" {
  type        = string
  default     = "rate(5 minutes)"
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). For more information, refer to the Azure documentation Schedule Expressions for Rules."
}

variable "function_env_vars" {
  type        = map(any)
  default     = null
  description = "List of Environment variables referred by function."
}

variable "tags" {
  type        = map(any)
  description = "List of Tags for the function."
  default = {
    "created_by" : "Terraform-Module: TechieInYou/scheduled-job/azure"
  }
}
