#/bin/bash
REV=$1

echo "[Escualo::WollokServer] Fetching GIT revision"
echo -n $REV > version

echo "[Escualo::WollokServer] Pulling docker image"
docker pull mumuki/mumuki-wollok-worker