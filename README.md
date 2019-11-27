# EDiscoveryTools

## Description

A module to help manage Azure Office 365 eDiscovery.
It helps connecting using modern authentication, adds comfort features such as tab completion and includes case & search creation accelerators.

It also allows creating preconfigured filter groups using a tag based approach:
Using configuration, you can define a label ("tag") and assign any number of mailboxes or group addresses to it.
These tags will then be available when creating searches, making it easier to create commonly applicable filter groups.

> This is especially designed for scenarios where a user has too many privileges to meaningfully use SecurityFilters (as these are used to grant new privileges, not constrain existing ones).

## Installation

```powershell
Install-Module EDiscoveryTools
```

This will install the module and all dependencies on your machine.

> PowerShellGet error

One dependency requires a current version of the PowerShellGet module to be available first.
If you encounter an error like that, run the following line:

```powershell
Install-Module PowerShellGet -Force -AllowClobber
```

Then _close the powershell console and start a new one_ .
This only takes effect on a new console!

## Connecting

Once installed, connecting to the service is a simple matter of running the following command:

```powershell
Connect-EDiscovery
```

(You will get prompted for credentials, this _does_ support MFA)

## Creating a new case

To create a new case, run:

```powershell
New-EDisCase -Name NewCaseName -CaseID "YourExternalCaseID"
```

Want to also create a search?

```powershell
New-EDisCase -Name NewCaseName -CaseID "YourExternalCaseID" -SearchName MySearch
```

Let's assume you had already defined the tag "Europe", pointing at all Distribution Groups that identify a user from Europe, having that filter to only apply to those would be a matter of:

```powershell
New-EDisCase -Name NewCaseName -CaseID "YourExternalCaseID" -SearchName MySearch -SearchTag Europe
```
