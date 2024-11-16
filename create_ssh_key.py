import os

key = os.environ['SSH_PRIVATE_KEY']

# split the key by all whitespace characters into lines
key = key.removeprefix("-----BEGIN OPENSSH PRIVATE KEY-----")
key = key.removesuffix("-----END OPENSSH PRIVATE KEY-----")
key = key.strip()
print("-----BEGIN OPENSSH PRIVATE KEY-----")
for line in key.split(" "):
    print(line)
print("----- END OPENSSH PRIVATE KEY-----")