# terraform-azure-scheduled-job
This Terraform module will package your Nodejs/Python code and upload to Azure Function, and schedule for running on specified intervals.  

This module is published in Terraform as **TechieInYou/scheduled-job/azure**.   


# Supported Languages
This module currently supports NodeJS and Python.  You can keep your node/python scripts in a folder and assign the folder path to **function_source_code_folder** variable. 


## NodeJS

### Supported version for Nodejs
    - 18
    - 16
    - 14
    - 12

### Supported versions for Python
    - 3.9
    - 3.8
    - 3.7
    - 3.6

### Recommended Folder Structure


