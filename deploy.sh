#!/bin/bash
# 部署 anyrouter-anthropic-test 容器
NAME=anyrouter-anthropic-test
IMG=python:3.11-slim
PORT_MAP=19998:9998
NODE_URL=http://172.17.0.1:4400
REPO=https://github.com/haimichenha/anyrouter2proxy.git

# 停止并删除旧容器（忽略错误）
docker stop $NAME 2>/dev/null
docker rm $NAME 2>/dev/null

CMD="set -e"
CMD="$CMD && apt-get update >/dev/null"
CMD="$CMD && apt-get install -y git >/dev/null"
CMD="$CMD && git clone $REPO /tmp/ar2p"
CMD="$CMD && cd /tmp/ar2p"
CMD="$CMD && pip install --no-cache-dir -r requirements.txt"
CMD="$CMD && python anyrouter2anthropic.py"

docker run -d \
  --name $NAME \
  -p $PORT_MAP \
  -e NODE_PROXY_URL=$NODE_URL \
  -e PORT=9998 \
  -e HOST=0.0.0.0 \
  $IMG \
  bash -lc "$CMD"

echo "Container $NAME started."
echo "Waiting for startup..."
sleep 30
docker logs --tail 20 $NAME
