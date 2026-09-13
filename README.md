# Automated AI-Based Case Triaging & Assignment Assistant

## 🚀 Overview

**Automated AI-Based Case Triaging & Assignment Assistant** is a Salesforce-based intelligent support platform that automates **Case classification, skill-based routing, shift-aware assignment, and operational notifications**.

The system combines **Salesforce automation, Claude AI, Queueable Apex, persistent round-robin assignment, and Microsoft Teams integration** to streamline the Case assignment process.

## 🔄 Solution Architecture

```text
Case Created
     │
     ▼
Queueable Apex
     │
     ▼
Claude AI Classification
     │
     ▼
Skill + Complexity Triage
     │
     ▼
Identify Active Shift Members
     │
     ▼
Eligible Members Found?
     │
     ├────────────── YES ──────────────┐
     │                                ▼
     │                    Persistent Round-Robin
     │                                │
     │                                ▼
     │                         Assign Case
     │
     └────────────── NO ───────────────┐
                                      ▼
                             Salesforce Notification
                                      +
                             Microsoft Teams Notification
                                      │
                                      ▼
                                Support Admin
                                      │
                                      ▼
                             Manual Monitoring
