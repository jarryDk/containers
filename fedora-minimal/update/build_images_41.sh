#!/bin/bash

container1=$(buildah from "${1:-fedora-minimal:41}")

## Get all updates
echo "Get all updates"
buildah run "$container1" -- microdnf update -y

## Clean up after update
echo "Clean up after update"
buildah run "$container1" -- microdnf clean all -y

buildah config --label org.label-schema.name="fedora-minimal-updated" "$container1"
buildah config --label org.label-schema.description="Fedora Minimal" "$container1"
buildah config --label org.label-schema.build-date="${build_date}" "$container1"
buildah config --label org.label-schema.vcs-url="https://github.com/jarrydk/containers" "$container1"
buildah config --label org.label-schema.version="41" "$container1"
buildah config --label org.label-schema.schema-version="1.0" "$container1"
buildah config --label maintainer="jarrydk" "$container1"
buildah config --label license="Apache License Version 2.0" "$container1"

#buildah commit "$container1" ${2:-docker.io/jarrydk/fedora-minimal-updates:41}
buildah commit "$container1" ${2:-localhost/jarrydk/fedora-minimal-updates:41}