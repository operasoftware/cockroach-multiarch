docker buildx build --platform linux/amd64,linux/arm64 -t operasoftware/cockroach-multiarch:21.2.4-4 -t operasoftware/cockroach-multiarch:latest --push .
