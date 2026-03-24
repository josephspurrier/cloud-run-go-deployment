# deployd

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

## How it works

You'll need to authenticate with Google Cloud first. Ensure your user has sufficient permissions.

1. `gcp-push` submits the source to Cloud Build, which builds a Docker image and pushes it to Google Container Registry.
2. The image is deployed to Cloud Run as a publicly accessible service.
3. Cloud Run automatically handles scaling and serves traffic on the assigned URL.
