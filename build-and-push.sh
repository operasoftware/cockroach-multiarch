docker buildx build --platform linux/amd64,linux/arm64 -t operasoftware/cockroach-multiarch:21.2.7-1 -t operasoftware/cockroach-multiarch:latest --push .
