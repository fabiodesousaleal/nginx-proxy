.PHONY: network certs clean_certs up stop restart status reload

HOST = 18.231.68.72
CA_PEM = ca.pem
NETWORK = proxy_network

network:
	@docker network inspect $(NETWORK) >/dev/null 2>&1 || docker network create $(NETWORK)
	@echo "Rede $(NETWORK) pronta."

certs:
	mkdir -p certs
	openssl genrsa -out certs/ca.key 4096
	openssl req -new -x509 -key certs/ca.key -out certs/ca.crt -days 3650 \
		-subj "/C=BR/ST=Tocantins/L=Araguaina/O=Local/OU=CA/CN=Local CA"
	openssl req -new -key certs/ca.key -out certs/ca.csr \
		-subj "/C=BR/ST=Tocantins/L=Araguaina/O=Local/OU=Server/CN=$(HOST)"
	printf "subjectAltName=IP:%s\n" "$(HOST)" > certs/san.ext
	openssl x509 -req -in certs/ca.csr -CA certs/ca.crt -CAkey certs/ca.key \
		-CAcreateserial -out certs/$(CA_PEM) -days 3650 \
		-extfile certs/san.ext
	@echo "Certificados gerados para https://$(HOST)/"

clean_certs:
	rm -rf certs

up: network
	@test -f certs/$(CA_PEM) || $(MAKE) certs
	docker compose up -d
	@echo "Proxy em https://$(HOST)/  (QGame) e https://$(HOST)/admin/"

stop:
	docker compose down

restart: stop up

status:
	docker compose ps

reload:
	docker compose exec nginx-proxy nginx -s reload

key:
	head -c 32 /dev/urandom | base64
