#!/bin/bash

echo "reading pkcs8 format certificate"
echo "writing some error" >&2

# read from STDIN to get the previous state
IN=$(cat)
# can we just get by with echoing the existing state?
echo "${IN}"

# # the quotes around KEY_DATA are IMPORTANT, they preserve newlines
# KEY_PUB=$(echo "${KEY_CONTENT}" | openssl rsa -pubout -outform DER | base64 -w0)
# KEY_PRI=$(echo "${KEY_CONTENT}" | openssl rsa -outform DER | base64 -w0)

# # save this output in STATE
# echo "{ \"public_key.der\": \"${KEY_PUB}\", \"private_key.der\": \"${KEY_PRI}\" }"