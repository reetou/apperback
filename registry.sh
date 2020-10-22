#!/bin/sh
TEST_IMAGE=test:1.10.4-otp-22
ELIXIR_IMAGE=elixir:1.10.4-otp-22

# Creating test image
docker build -f test.Dockerfile -t registry.gitlab.com/$GITLAB_USERNAME/$PROJECT_NAME/$TEST_IMAGE .

# Creating deploy image
docker build -f build.Dockerfile -t registry.gitlab.com/$GITLAB_USERNAME/$PROJECT_NAME/$ELIXIR_IMAGE .


# Pushing elixir image to registry
docker push registry.gitlab.com/$GITLAB_USERNAME/$PROJECT_NAME/$ELIXIR_IMAGE
# Pushing test image to registry
docker push registry.gitlab.com/$GITLAB_USERNAME/$PROJECT_NAME/$TEST_IMAGE