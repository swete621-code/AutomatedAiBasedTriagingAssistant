Automated AI-Based Case Triaging & Assignment Assistant
🚀 Overview

Automated AI-Based Case Triaging & Assignment Assistant is a Salesforce-based intelligent support platform built with the following design principle:

Case
  ↓
Salesforce + Claude
  ↓
Skill + Complexity Triage
  ↓
Active Shift Members
  ↓
Eligible Members Found?
  ├── YES → Persistent Round-Robin → Assign Case
  │
  └── NO → Salesforce Notification
             +
           Microsoft Teams Notification
             ↓
        Support Admin
             ↓
        Manual Monitoring
✨ Key Features

Skill & Complexity-Based Routing — Uses Claude to intelligently classify each support case based on the required skill and complexity, with Salesforce responsible for the subsequent routing decision.

Asynchronous AI Classification & Routing — The complete classification and assignment workflow is executed asynchronously using Queueable Apex. This allows Salesforce to perform the external Claude callout, process the AI response, identify eligible Shift Members, and execute the round-robin assignment without blocking the original Case transaction.

Round-Robin Assignment — Salesforce automatically assigns eligible cases to available Shift Members using a persistent round-robin mechanism, ensuring fair and continuous distribution of cases across eligible members.

No-Member Fallback Handling — If no eligible Shift Members are found in the active shift, the case is not incorrectly assigned. Instead, the system triggers a fallback process for manual intervention by the Support Admin.

Salesforce + Microsoft Teams Notifications — When a case cannot be automatically assigned, the Support Admin is notified through Salesforce and Microsoft Teams integration, allowing the admin to manually monitor and take action.

Secure Integration Architecture — External integrations follow Salesforce best practices using Named Credentials, External Credentials, and Named Principal authentication rather than hard-coding credentials in Apex.

Salesforce → Claude: Uses API Key authentication, securely managed through Salesforce Named Credentials and External Credentials.
Salesforce → Microsoft Teams: Uses OAuth 2.0 Client Credentials flow with Client Secret authentication, managed through Salesforce Named Credentials and External Credentials.
Authentication credentials are kept outside Apex code to improve security, maintainability, and centralized credential management.

Data Modeling & Relationships — Implements a structured Salesforce data model using One-to-One, One-to-Many, and Many-to-Many relationships to represent business entities such as Shifts, Shift Members, Skills, Designations, and their associations. Junction objects are used where required to support Many-to-Many relationships, enabling flexible and scalable case-routing logic.

Operations Dashboard — The custom Lightning Web Component dashboard provides visibility into:

Active Shift
Shift Timing
Cases
Assignment
Status
Priority
Subject
Description
Active Shift Members
Skills
Designations

The UI is built using Lightning Web Components and Salesforce Lightning Design System (SLDS).

🔐 Security

The project follows Salesforce security and integration best practices:

with sharing where appropriate
Object-level permissions
Field-level security
Controlled Experience Cloud guest access
OAuth-based authentication
Named Credentials
External Credentials
No hard-coded API secrets
Dedicated integration authentication
📸 Screenshots

image image

🌐 Experience Cloud

The application is exposed through a Salesforce Experience Cloud site.

🚀 Live Demo

Open the Automated Case Assignment Dashboard

Note: The demo runs on a Salesforce Developer/Org Farm environment, so availability may depend on the org and Experience Cloud site being active.

🧩 Salesforce Technology Stack
Technology	Purpose
Apex	Core business logic and integrations
Apex REST	External API
Queueable Apex	Asynchronous processing
SOQL	Data retrieval and routing
Lightning Web Components	Operations dashboard
Salesforce Flow	Declarative automation
Platform Events	Event-driven integration
Change Data Capture	Record-change events
Named Credentials	Secure callouts
External Credentials	Authentication
Microsoft Graph API	Teams notifications
External AI API	Case classification
Experience Cloud	Customer/public-facing experience
Custom Objects / Metadata	Shift, skills and routing configuration
Git / GitHub	Version control
GitHub Actions	CI/CD

🧪 CI/CD & Source Control

The project is maintained using Git and GitHub, with CI/CD automation through GitHub Actions.

Recommended workflow:

Feature Branch
      ↓
Pull Request
      ↓
GitHub Actions
      ↓
Salesforce Validation
      ↓
Apex Tests
      ↓
Merge
      ↓
Deployment

🛠️ Getting Started
Prerequisites
Salesforce CLI
VS Code
Salesforce Extension Pack
Git
Salesforce Developer/Sandbox/Target Org
Credentials for required external integrations
Clone the Repository
git clone https://github.com/swete621-code/AutomatedAiBasedTriagingAssistant.git
cd AutomatedAiBasedTriagingAssistant
Authenticate with Salesforce
sf org login web
Set Target Org
sf config set target-org=YOUR_ORG_ALIAS
Deploy Salesforce Source
sf project deploy start --source-dir force-app --target-org YOUR_ORG_ALIAS

📌 Future Enhancements
⏱️ SLA countdown and breach monitoring
📊 Advanced agent workload balancing
🤖 AI confidence-based human review
🌐 Customer-facing case creation portal
🔎 Customer case status tracking
🔁 Retry and failure handling for external APIs
📈 Advanced operational analytics
🚀 Automated CI/CD deployment gates
