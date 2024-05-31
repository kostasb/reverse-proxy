#!/bin/sh
echo "Creating test environment"
docker build -t e2etests e2etests >/dev/null 2>&1
docker run -v ./e2etests:/scripts:rw e2etests