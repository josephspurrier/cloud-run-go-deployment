# This Makefile is an easy way to run common operations.
# Execute commands like this:
# * make
# * make gcp-push
# * make run
# * make docker-build

# Load the environment variables.
include .env
export

.PHONY: default
default: gcp-push

################################################################################
# Deploy application
################################################################################

.PHONY: run
run:
	@echo Starting local server.
	go run main.go

.PHONY: docker-build
docker-build:
	@echo Building Docker image.
	docker build -t $(GCP_IMAGE_NAME) .

.PHONY: gcp-push
gcp-push:
	@echo Pushing to Google Cloud Run.
	gcloud --project=$(GCP_PROJECT_ID) builds submit --tag gcr.io/$(GCP_PROJECT_ID)/$(GCP_IMAGE_NAME)
	gcloud --project=$(GCP_PROJECT_ID) run deploy $(GCP_CLOUDRUN_NAME) \
		--image gcr.io/$(GCP_PROJECT_ID)/$(GCP_IMAGE_NAME) \
		--platform managed \
		--allow-unauthenticated \
		--region $(GCP_REGION)

.PHONY: gcp-remove
gcp-remove:
	@echo Removing Google Cloud Run service.
	gcloud --project=$(GCP_PROJECT_ID) run services delete $(GCP_CLOUDRUN_NAME) \
		--platform managed \
		--quiet \
		--region $(GCP_REGION)
