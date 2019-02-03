#!/bin/bash

DEFAULT_TAG_NAME="alcs:latest"
TAG_NAME="${1:-$DEFAULT_TAG_NAME}"
docker build -f docker/update.dockerfile . -t ${TAG_NAME} --build-arg ${DEFAULT_TAG_NAME}