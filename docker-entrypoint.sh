#!/usr/bin/env bash
export PORT=":${PORT}"
# Execute the rest of your ENTRYPOINT and CMD as expected.
exec "$@"