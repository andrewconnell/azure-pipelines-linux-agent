# ![Azure Pipelines](/docs/DevOpsIconPipelines40.png "Azure Pipelines") ![Docker](/docs/DockerIcon40.png "Docker") Azure Pipeline Linux Agent (Docker image)

This is a custom Azure Pipelines agent created as a Linux container to replace the deprecated [Microsoft Pipelines Agent](https://hub.docker.com/_/microsoft-azure-pipelines-vsts-agent). It is based off **Ubuntu 16.04** & contains some of the software that is installed on the Microsoft-hosted Ubuntu 16.04 agents.

The image is based on a merge of the instructions [Running a self-hosted agent in Docker: Linux](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#adding-tools-and-customizing-the-container) & adding installer scripts from the official images found in the Github repo [Microsoft/azure-pipelines-image-generation](https://github.com/Microsoft/azure-pipelines-image-generation).

> Only some of the software installed on the base Ubuntu hosted VM agent's that Microsoft maintains is installed in this image.

## How to Use this Image

The Azure Pipelines agent must be started with account connection information, provided through environment variables:

|  Env Variable  |                                             Description                                             |             Example             |
| -------------- | --------------------------------------------------------------------------------------------------- | ------------------------------- |
| AZP_URL        | **required** Url to the Azure DevOps account                                                        | *https://dev.azure.com/contoso* |
| AZP_TOKEN      | **required** Azure DevOps user account personal access token (PAT) granting access to the `AZP_URL` | ******                          |
| AZP_AGENT_NAME | **optional** Name of the agent. If not specified, the container's hostname is used                  | *mydockeragent*                 |
| AZP_POOL       | **optional** Azure Pipelines agent pool name. If not specified, `Default` is used.                  | *My Custom Agent Pool*          |
| AZP_WORK       | **optional** Work directory. If not specified, `_work` is used.                                     | *_work*                         |

Examples:

```sh
# run detached mode creating an agent named "mydockeragent"
docker run \
  -d
  -e AZP_URL=https://dev.azure.com/contoso \
  -e AZP_TOKEN=m23qugcXXXXXXXXXXXXXXXmvurfvra \
  -e AZP_AGENT_NAME=mydockeragent \
  andrewconnell/azure-pipelines-linux-agent:latest
# run in detached mode, using the container hostid as the agent name
docker run \
  -e AZP_URL=https://dev.azure.com/contoso \
  -e AZP_TOKEN=m23qugcXXXXXXXXXXXXXXXmvurfvra \
  andrewconnell/azure-pipelines-linux-agent:latest
```

Once the agent is running, it will appear in the list of agents in the specified DevOps pipeline agent pool.

## How it Works

Running the image will execute the `start.sh` script. This script checks for required environment variables first & then downloads+installs the latest Azure Pipelines agent. After installing the latest agent, it configures it and starts it up to listen for jobs.

## Building the Image

```sh
docker build -t azure-pipelines-linux-agent:latest .
```
