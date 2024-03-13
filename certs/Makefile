.PHONY: certs
HOST = 127.0.0.1
certs:
	openssl genrsa -out ca.key 4096 && openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/C=BR/ST=Tocantins/L=Araguaína/O=GitLab/OU=CA/CN=GitLab CA" && openssl req -new -key ca.key -out ca.csr -subj "/C=BR/ST=Tocantins/L=Araguaína/O=GitLab/OU=Server/CN=127.0.0.1.nip.io" && openssl x509 -req -in ca.csr -CA ca.crt -CAkey ca.key -out ca.pem -days 3650