# OpenSSL

```bash
# Verify a PEM  
openssl x509 -inform PEM -in  agent.crt.pem  -noout -text

# Convert cert to PEM format
openssl x509 -in rabbitmq.crt -outform PEM -out rabbitmq.crt.pem

# Connect to server and show certs
openssl s_client -showcerts -connect pluralsight.com:443

# To debug openssl/certs on a server start openssl server ... 
openssl s_server -key key.pem -cert cert.pem

# .. connect to server
openssl s_client -connect server.com:443 -ssl3
```

- https://blog.jorisvisscher.com/2015/07/22/create-a-simple-https-server-with-openssl-s_server/