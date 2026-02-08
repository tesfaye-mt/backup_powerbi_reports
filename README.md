# Power BI Report Backup Automation

Automated **PowerShell-based backup solution** for exporting Power BI reports (PBIX) from all accessible workspaces.

Designed for **enterprise DBA / DevOps environments**, this utility provides:

- Secure authentication
- Workspace and report discovery
- Safe filename sanitization
- Structured folder organization
- Logging and error handling
- Ready for scheduling (Task Scheduler / SQL Agent / CI/CD)

---

## Overview

This script connects to the Power BI Service and exports PBIX files for all workspaces and reports the service account has access to.

Backups are organized using the following structure:
   BackupRoot/
   WorkspaceName/
   ReportName_yyyyMMdd.pbix

## Features

- Exports all workspaces automatically
- Sanitizes file and folder names (prevents invalid Windows characters)
- Prevents overwrite conflicts
- Structured error handling
- Supports automation (SQL Agent / scheduled jobs)
- No hard-coded secrets (uses environment variables or service principal authentication)
- Enterprise-ready design
