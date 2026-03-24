# Use the official golang image to create a binary.
# https://hub.docker.com/_/golang
FROM golang:1.25-alpine AS builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux go build -mod=readonly -v -o server

# Use the distroless static image for a lean production container.
# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/static
COPY --from=builder /app/server /app/server

# Run the web service on container startup.
CMD ["/app/server"]
