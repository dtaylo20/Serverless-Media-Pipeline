# Serverless AI Media Pipeline

## 🚀 Project Overview
A fully automated, event-driven cloud pipeline that uses AI to analyze images. When a user uploads a photo to an S3 bucket, a Lambda function is triggered to identify objects using Amazon Rekognition and store the metadata in DynamoDB.

## 🛠️ Tech Stack
* **Cloud Provider:** AWS (S3, Lambda, DynamoDB, Rekognition, IAM)
* **Infrastructure as Code:** Terraform
* **Language:** Python (Boto3 SDK)
* **DevOps:** GitHub Codespaces & Git for Version Control

## 📐 Architecture
1. **S3 Bucket:** Acts as the entry point for media uploads.
2. **Lambda Trigger:** Automatically executes code upon S3 `ObjectCreated` events.
3. **AWS Rekognition:** Analyzes the image to detect labels/objects.
4. **DynamoDB:** Stores the image name and AI-generated labels for permanent record.

## 🔧 How to Deploy
1. Clone the repository.
2. Initialize Terraform: `terraform init`
3. Deploy Infrastructure: `terraform apply`
4. Upload an image to the generated S3 bucket to see the AI labels populate in DynamoDB.

## 🎓 Academic Context
This project was developed as part of the **Version Control (D197)** course at **Western Governors University**. It demonstrates proficiency in managing infrastructure code, handling large-scale Git history issues, and implementing serverless cloud patterns.