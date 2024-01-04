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
You can deploy multiple functions by keeping its code in seperate folders  (eg. job1, job2, etc.) by following below folder structure.  
```
.
├── host.json
├── job1 (folder)
│   ├── function.json
│   ├── index.js / index.py  (main script with your business logic)
│   ├── other files referred by main script, if any
│   └── readme.md (optional)
└── jobN (folder)
    └── same structure as job1
```

#### host.json content

```
{
    "version": "2.0",
    "extensionBundle": {
        "id": "Microsoft.Azure.Functions.ExtensionBundle",
        "version": "[4.*, 5.0.0)"
    }
}
```

#### function.json content

```
{
  "scriptFile": "<script file: index.js/index.py>",
  "bindings": [
    {
      "name": "myTimer",
      "type": "timerTrigger",
      "direction": "in",
      "schedule": "0 */5 * * * *"
    }
  ]
}
```







