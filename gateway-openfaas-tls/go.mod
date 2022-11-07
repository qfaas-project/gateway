module github.com/openfaas/faas/gateway

go 1.15

require (
	github.com/beorn7/perks v1.0.1
	github.com/docker/distribution v2.7.1+incompatible
	github.com/gogo/protobuf v1.3.0
	github.com/golang/protobuf v1.3.2
	github.com/gorilla/mux v1.7.3
	github.com/matttproud/golang_protobuf_extensions v1.0.1
	github.com/nats-io/jwt v0.3.2
	github.com/nats-io/nats.go v1.9.2
	github.com/nats-io/nkeys v0.1.0
	github.com/nats-io/nuid v1.0.1
	github.com/nats-io/stan.go v0.6.0
	github.com/openfaas/faas v0.0.0-20200422113858-a7c6c3920078
	github.com/openfaas/faas-provider v0.0.0-20191005090653-478f741b64cb
	github.com/openfaas/nats-queue-worker v0.0.0-20200422114215-1f4e16e1f7af
	github.com/prometheus/client_golang v1.1.0
	github.com/prometheus/client_model v0.0.0-20190812154241-14fe0d1b01d4
	github.com/prometheus/common v0.7.0
	github.com/prometheus/procfs v0.0.5
	go.uber.org/goleak v0.10.0
	golang.org/x/crypto v0.0.0-20191002192127-34f69633bfdc
	golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9
)
