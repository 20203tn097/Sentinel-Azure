# Azure Sentinel Information Model (ASIM) ProcessEvent parsers 

This template deploys all ASIM ProcessEvent parsers. The template is part of the Azure Sentinel Information Mode (ASIM).

The Azure Sentinel Information Mode (ASIM) enables you to use and create source-agnostic content, simplifying your analysis of the data in your Azure Sentinel workspace.

For more information, see:

- [Normalization and the Azure Sentinel Information Model (ASIM)](https://aka.ms/AzSentinelNormalization)
- [Azure Sentinel ProcessEvent normalization schema reference](https://aka.ms/AzSentinelProcessEventDoc)

<br>

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://aka.ms/AzSentinelProcessEventARM)

<br>

The template deploys the following:
* imProcess - Process Events from all normalized process events sources
* imProcessCreate - Process creation Events from all normalized process events sources
* imProcessTerminate - Process termination Events from all normalized process events sources
* vimProcessEventsMicrosoft365D - Process events from Microsoft 365 Defender for Endpoints
* vimProcessCreateMicrosoftSysmon - Process creation events from Sysmon
* vimProcessTerminateMicrosoftSysmon - Process termination events from Sysmon
* vimProcessCreateLinuxSysmon - Process creation events from Sysmon on Linux
* vimProcessCreateMicrosoftSecurityEvents - Process creation events from Security Events
* vimProcessTerminateMicrosoftSecurityEvents - Process termination Events from Security Events
* vimProcessEmpty - Empty ASim Process table

<br>

