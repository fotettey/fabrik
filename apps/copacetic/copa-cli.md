1. Run BUildKit container:

```
docker run --rm -d --privileged -p 127.0.0.1:8888:8888/tcp --name buildkitd moby/buildkit:v0.18.2 -addr tcp://0.0.0.0:8888docker run --rm -d --privileged -p 127.0.0.1:8888:8888/tcp --name buildkitd moby/buildkit:v0.18.2 -addr tcp://0.0.0.0:8888

```


## Ensure that image exists in remote image registry:
### docker image tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```
BASE_IMAGE=fotettey/jenkins
PRE_TAG=jcasc
docker image tag jenkins:jcasc $BASE_IMAGE:$PRE_TAG
```

2. Scan the image with preferred scanner, Trivy
```
trivy image --ignore-unfixed -f table $BASE_IMAGE:$PRE_TAG
trivy image --list-all-pkgs --ignore-unfixed -f json -o $PRE_TAG.json $BASE_IMAGE:$PRE_TAG

cat $PRE_TAG.json
```

3. Copa patching step:

```
# copa patch -r $PRE_TAG.json -i fotettey/jenkins:jcasc -t jcasc-patched -a tcp://0.0.0.0:8888 --timeout 50m

copa patch -r $PRE_TAG.json -i $BASE_IMAGE:$PRE_TAG -t $PRE_TAG-patched -a tcp://0.0.0.0:8888 --timeout 50m

```


4. Verify Patch

```
PATCHED_IMAGE=$BASE_IMAGE:$PRE_TAG-patched
trivy image --ignore-unfixed -f table $PATCHED_IMAGE

```


5. Stop BuildKit backend image builder container:

```
docker rm buildkitd --force
```