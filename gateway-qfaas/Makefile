.PHONY: all build push
TAG?=latest
NS?=qfaas

all:	build
build:
	./build.sh ${TAG} ${NS}
push:
	./push.sh ${TAG} ${NS}
