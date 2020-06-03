# Ingest-Prisma
author: Nathan Swift

This Logic App connector will act as a Webhook listener, Prisma can then send an array of events to it and it will send the events to Azure Sentinel - Prisma_CL  

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Sentinel%2FPlaybooks%2Fmaster%2FIngest-Prisma%2Fazuredeploy.json" target="_blank">
    <img src="https://aka.ms/deploytoazurebutton"/>
</a>
<a href="https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Sentinel%2FPlaybooks%2Fmaster%2FIngest-Prisma%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazuregov.png"/>
</a>

**Additional Post Install Notes:**

Prisma webhook implementation details can be found here: https://techcommunity.microsoft.com/t5/azure-sentinel/connecting-prisma-to-sentinel/m-p/1408693