# SAP S/4HANA Cloud Extensions – Native iOS Offline Timesheet App
This repository contains the sample code for the [Native iOS Offline Timesheet App tutorial](https://tiny.cc/s4-timesheet-ios).  

*This code is only one part of the tutorial, so please follow the tutorial before attempting to use this code.*

## Description

This extensibility scenario showcases the Native iOS Offline Timesheet app, which can be referred to as an alternative – or even an addition – to the standard Manage My Timesheet SAP S/4HANA Cloud time recording app. With this alternative app, your employees can record their working times on their iOS devices. Each recorded task includes start and end times, a recording date, and a task type (predefined with some sample tasks). With the app, you can create, update, or delete working times (internet connection required). Additionally, the app leverages offline capabilities which makes it possible for employees to access their existing timesheet records on their mobiles devices even if there's no internet connection.

#### Overview about the app's and system landscape architecture
![Architecture](Architecture.png)

#### SAP Extensibility Explorer

This tutorial is one of multiple tutorials that make up the [SAP Extensibility Explorer](https://sap.com/extends4) for SAP S/4HANA Cloud.
SAP Extensibility Explorer is a central place where anyone involved in the extensibility process can gain insight into various types of extensibility options. At the heart of SAP Extensibility Explorer, there is a rich repository of sample scenarios which show, in a hands-on way, how to realize an extensibility requirement leveraging different extensibility patterns.


Requirements
-------------
- An account in SAP Cloud Platform with a subaccount in the Neo environment and Mobile Services enabled.
- An SAP S/4HANA Cloud tenant. **This is a commercial paid product.**
- A SAML 2.0 Identity Provider. We recommend to use SAP Cloud Platform Identity Authentication.
- A Mac Device with **Xcode 11.6 (11E708)** and **SAP Cloud Platform SDK for iOS (XCode 11.5) 5.1.0**.
- Tested and runned with **iOS 13.6**


Download and Installation
-------------
This repository is a part of the [Download and Configure the Sample App](https://help.sap.com/viewer/80ceaf9e74574004873d675445e0ec84/SHIP/en-US/53299941e6c04e46b595d368bfc7fad3.html) step in the tutorial. Instructions for use can be found in that step.

[Please download the zip file by clicking here](https://github.com/SAP/s4hana-ext-timesheet-ios/archive/master.zip) so that the code can be used in the tutorial.  


Known issues
---------------------
Please check out the [Troubleshooting section](Troubleshooting.md) which handles some known issues for this scenario.

How to obtain support
---------------------
If you have issues with this sample, please open a report using [GitHub issues](https://github.com/SAP/s4hana-ext-timesheet-ios/issues).

License
-------
Copyright © 2020 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
