#!/bin/bash
set -e
SERVICE=$1
REPO_URL="https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git"
WORKDIR="/opt/$SERVICE"
if [ -z "$SERVICE" ]; then
  exit 1
fi
if [ ! -d "$WORKDIR" ]; then
  git clone "$REPO_URL" "$WORKDIR"
fi
cd "$WORKDIR"
git fetch --all
git reset --hard origin/HEAD
cd "$WORKDIR/$SERVICE"
if [ "$SERVICE" = "service-a" ]; then
  npm ci
  systemctl daemon-reload || true
  systemctl restart service-a || systemctl start service-a || true
elif [ "$SERVICE" = "service-b" ]; then
  python3 -m venv .venv || true
  . .venv/bin/activate
  pip install -r requirements.txt
  systemctl daemon-reload || true
  systemctl restart service-b || systemctl start service-b || true
fi
