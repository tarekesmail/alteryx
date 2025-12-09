
#!/bin/sh

echo "deleting pkcs8 format certificate"

# read from STDIN to get the existing state
IN=$(cat)

# since we are deleting the object, we can simply echo an empty state
echo "{}"