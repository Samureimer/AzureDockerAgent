# AzureDockerAgent
A docker containerized agent for Android, NetCore ASP and Angular builds

I needed a container to pose as a self hosted Azure DevOps pipeline agent.
I needed to build the following for my project:

ASP.Net Core - My backend API for my project.
Typescript - My Angular frontend build with NPM.
Xamarin Android - My Xamarin app.


I had to manually add the **Xamarin.Android** capability to my agent in Azure DevOps.
![image](https://user-images.githubusercontent.com/5878260/115853881-f1aa0d00-a429-11eb-9136-a1fbe32b5dae.png)


I got a lot in inspiration and help from the following articles and posts:
https://askubuntu.com/questions/1177970/how-to-develop-for-android-with-xamarin
https://linuxize.com/post/how-to-install-mono-on-ubuntu-20-04/
https://github.com/nathansamson/xamarin-android-docker/blob/master/Dockerfile
https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/build/xamarin-android?view=azure-devops
https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu
https://github.com/vfabing/azure-pipelines-agent-docker-dotnet-core-sdk/blob/master/Dockerfile
https://wakeupandcode.com/yaml-defined-ci-cd-for-asp-net-core-3-1/

Build the docker agent with: **docker build -t dockeragent:latest .**
Run the agent with: **docker run --name CONTAINER_NAME -e AZP_URL=https://dev.azure.com/YOUR_ORGANIZATION/ -e AZP_TOKEN=YOUR_PAT_TOKEN -e AZP_AGENT_NAME=AGENT_NAME dockeragent:latest**

PAT Access levels:
https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page
_For example, to create a token to enable a build and release agent to authenticate to Azure DevOps Services, limit your token's scope to Agent Pools (Read & manage). To read audit log events, and manage and delete streams, select Read Audit Log, and then select Create._


My projects contain submodules that I have in a repository in the same DevOps project.
To allow the agent to pull these submodules when building I had to **turn off** these settings on **BOTH** the **organization** settings **AND** the **project** settings:
![image](https://user-images.githubusercontent.com/5878260/115855282-5dd94080-a42b-11eb-88f7-9147a46d4952.png)




