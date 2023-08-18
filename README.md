# OpenConnect in a Docker Container

Run OpenConnect VPN inside a Docker container. To make connections more manageable, an SSH layer is added on top.

## How to Run

### 1. Build the Docker Image

To build the Docker image, use the following command:
```bash
docker build -t openconnect_box .
```

### 2. Run the Docker Container

Start the Docker container using the following command:

```bash
docker run -it --rm \
    -e VPN_SERVER="SERVER_ADDRESS" \
    -e VPN_USERNAME="USERNAME" \
    -e VPN_PASSWORD_BASE64="MY_PASSWORD_IN_BASE64" \
    --cap-add NET_ADMIN --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    -v ~/.ssh/authorized_keys:/root/.ssh/authorized_keys \
    -p 2222:22 \
    openconnect_box
```
### Generating Base64 Encoded Password

If you need to generate a base64 encoded string from your password, you can use the following command:

```bash
echo -n "YOUR_PASSWORD" | base64
```

Replace `YOUR_PASSWORD` with your actual password.


**Note**: 

- Replace `SERVER_ADDRESS`, `USERNAME`, and `MY_PASSWORD_IN_BASE64` with your respective VPN credentials.
- The above command also mounts your `~/.ssh/authorized_keys` to the container's `/root/.ssh/authorized_keys` directory. Ensure you have the `authorized_keys` file in place if you wish to use SSH.
- The container exposes the SSH port on `2222` of the host machine.
