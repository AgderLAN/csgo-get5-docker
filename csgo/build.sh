#!/bin/bash

TAG_NAME="alcs:latest"
docker build -f docker/build.dockerfile . -t ${TAG_NAME}