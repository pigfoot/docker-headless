#!/usr/bin/env sh

TIMEOUT=10

/usr/bin/chromium-browser \
    --remote-debugging-port=9222 \
    --headless \
    2>/dev/null 1>&2 &

while :; do
    res=$(wget -q -t 1 --spider localhost:9222 2>&1)
    status=$?
    if [ ${status} -eq 0 ]; then
        # this is not really expected unless a key lets you log in
        break
    fi

    TIMEOUT=$((TIMEOUT-1))
    if [ $TIMEOUT -eq 0 ]; then
        echo "timed out"
        # error for jenkins to see
       exit 1
    fi
    sleep 1
done

/usr/src/app/node_modules/.bin/chrome-har-capturer -i ${1} 2> /dev/null
