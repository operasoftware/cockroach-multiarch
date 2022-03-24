docker buildx build --platform linux/amd64,linux/arm64 -t asgavar/cockroach-multiarch:21.2.4-2 -t asgavar/cockroach-multiarch:latest --push .
