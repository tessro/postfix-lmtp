container:
	docker build -t quay.io/paulrosania/postfix-lmtp .

release:
	docker push quay.io/paulrosania/postfix-lmtp

default: container
