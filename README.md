# Google Cloud Deployment Template

The project demonstrates how to package a minimal Go HTTP server that deploys to Google Cloud Run via Docker and Cloud Build.

## Prerequisites

- [Go](https://golang.org/dl/)
- [Docker](https://www.docker.com/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud`)
- A GCP project with Cloud Run and Cloud Build APIs enabled

## Configuration

Copy the example below into a `.env` file at the root of the project and fill in your values:

```
GCP_PROJECT_ID=your-gcp-project-id
GCP_REGION=us-central1
GCP_IMAGE_NAME=helloworld
GCP_CLOUDRUN_NAME=helloworld
```

The `.env` file is excluded from version control.

## Usage

| Command                   | Description                               |
| ------------------------- | ----------------------------------------- |
| `make` or `make gcp-push` | Build and deploy the service to Cloud Run |
| `make gcp-remove`         | Delete the Cloud Run service              |
| `make run`                | Run the server locally                    |
| `make docker`             | Build the Docker image locally            |

## Required GCP Permissions

Your GCP user or service account needs the following IAM roles on the project:

| Role                             | Purpose                                                |
| -------------------------------- | ------------------------------------------------------ |
| `roles/cloudbuild.builds.editor` | Submit builds via Cloud Build                          |
| `roles/storage.admin`            | Push Docker images to Container Registry               |
| `roles/run.admin`                | Deploy, update, and delete Cloud Run services          |
| `roles/iam.serviceAccountUser`   | Act as the Cloud Run service account during deployment |

Authenticate before running any `make` commands:

```sh
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## PORT Environment Variable

Cloud Run automatically injects a `PORT` environment variable into the container. Your application must listen on this port rather than a hardcoded value. The default is `8080`.

This server reads `PORT` at startup:

```go
port := os.Getenv("PORT")
if port == "" {
    port = "8080"
}
```

You can override the default by specifying a custom port when deploying. See the [Cloud Run container port docs](https://docs.cloud.google.com/run/docs/configuring/services/containers#configure-port) for details.

## How it works

You'll need to authenticate with Google Cloud first. Ensure your user has sufficient permissions.

1. `gcp-push` submits the source to Cloud Build, which builds a Docker image and pushes it to Google Container Registry.
2. The image is deployed to Cloud Run as a publicly accessible service.
3. Cloud Run automatically handles scaling and serves traffic on the assigned URL.
