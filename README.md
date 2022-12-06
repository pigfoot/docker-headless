# 3 ways to securely use Chrome Headless with this image

## ❌ With nothing

Launching the container using only `docker container run -it pigfoot/headless ...` will fail with some logs similar to [#33](https://github.com/Zenika/alpine-chrome/issues/33).

Please use the 3 others ways to use Chrome Headless.

## ✅ With `--no-sandbox`

Launch the container using:

`docker container run -it --rm -v $(pwd)/src:/app/src pigfoot/headless` and use the `--no-sandbox` flag for all your commands.

Be careful to know the website you're calling.

Explanation for the `no-sandbox` flag in a [quick introduction here](https://www.google.com/googlebooks/chrome/med_26.html) and for [More in depth design document here](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)

## ✅ With `SYS_ADMIN` capability

Launch the container using:
`docker container run -it --rm --cap-add=SYS_ADMIN -v $(pwd)/src:/app/src pigfoot/headless`

This allows to run Chrome with sandboxing but needs unnecessary privileges from a Docker point of view.

## ✅ The best: With `seccomp`

Thanks to ever-awesome Jessie Frazelle seccomp profile for Chrome. This is The most secure way to run this Headless Chrome docker image.

[chrome.json](https://github.com/pigfoot/docker-headless/raw/master/chrome.json)

Also available here `wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`

Launch the container using:
`docker container run -it --rm --security-opt seccomp=$(pwd)/chrome.json -v $(pwd)/src:/app/src pigfoot/headless`

# Run with HAR

`docker container run -it --rm --security-opt seccomp=$(pwd)/chrome.json pigfoot/headless ./headless.sh https://httpbin.org/get`

# Docker Image

[DockerHub](https://hub.docker.com/r/pigfoot/headless)
