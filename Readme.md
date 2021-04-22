# Deploy multiple data disks based on a configuration file.

## Usage

Create a JSON file to represent the server being deployed e.g. server1.json

Fill out the details as similar to below ensuring that the number of data disks and sizes are specified.

```
{
    "computerName": "server1",
    "virtualNetworkName": "vnet01",
    "numberOfDisks": 2,
    "sizeOfDisks": [
        "30",
        "50"
    ]
}
```

Deploy using :

```
.\deploy.ps1 -DeploymentFile .\server1.json
```
