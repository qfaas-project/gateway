# QFaaS Note for gateway-qfaas

gateway component for QFaaS project

Version: based on OpenFaaS [gateway](https://github.com/openfaas/faas/tree/master/gateway) commit `571cad7`

## Build Instruction

```shell script
bash build.sh v3.0 qfaas
docker images
# You should find a docker image called qfaas/gateway-qfaas:v3.0
# You can use any version number you like instead of 'v3.0'
```

## Information

 - Difference from [gateway-qfaas-post1rtt](https://github.com/qfaas-project/gateway/tree/main/gateway-qfaas-post1rtt)
    - All HTTP action will be treated as QUIC `0RTT` request by this gateway
 - We updated the go version from `1.13` to `1.15` in `Dockerfile` to support the newer `quic-go`
 - To get all the major modifications, please `diff` the following files to the original version
    - [main.go](main.go): create a QUIC client for the function proxy
    - [Dockerfile](Dockerfile)
    - [types/proxy_client.go](types/proxy_client.go): the QUIC client definition
    - [types/pauling.crt](types/pauling.crt): this self-signed RootCA is just for prototype testing purpose
    - [certs](certs): this self-signed certificate is just for prototype testing purpose
    - [handlers/forwarding_proxy.go](handlers/forwarding_proxy.go): forward requests by `https`
    - [http3/client.go](vendor/github.com/lucas-clemente/quic-go/http3/client.go): please also check the `quic-go` [readme.md](vendor/github.com/lucas-clemente/quic-go/README.md)

# Original OpenFaaS Readme

# Gateway

The API Gateway provides an external route into your functions and collects Cloud Native metrics through Prometheus. The gateway also has a UI built-in which can be used to deploy your own functions or functions from the OpenFaaS Function Store then invoke them.

The gateway will scale functions according to demand by altering the service replica count in the Docker Swarm or Kubernetes API. Custom alerts generated by AlertManager are received on the /system/alert endpoint.

In summary:

* Built-in UI Portal
* Deploy functions from the Function Store or deploy your own
* Instrumentation via Prometheus
* Auto-scaling via AlertManager and Prometheus
* Scaling up from zero
* REST API available documented with Swagger

![OpenFaaS Gateway](https://docs.openfaas.com/images/of-conceptual-operator.png)

*Pictured: conceptual architecture when Kubernetes is used as the orchestration provider*

## Function Providers

Providers for functions can be written using the [faas-provider](https://github.com/openfaas/faas-provider/) interface in Golang which provides the REST API for interacting with the gateway. The gateway originally interacted with Docker Swarm directly and anything else via a Function Provider - this support was moved into a separate project [faas-swarm](https://github.com/openfaas/faas-swarm/).

## REST API

Swagger docs: https://github.com/openfaas/faas/tree/master/api-docs

## CORS

By default the only CORS path allowed is for the Function Store which is served from the GitHub RAW CDN.

## UI Portal

The built-in UI Portal is served through static files bound at the /ui/ path.

The UI was written in Angular 1.x and makes uses of jQuery for interactions and the Angular Material theme for visual effects and components.

View the source in the [assets](./assets/) folder.

### Function Store

The Function Store is rendered through a static JSON file served by the GitHub RAW CDN. The Function Store can also be used via the [OpenFaaS CLI](https://github.com/openfaas/faas-cli).

See the [openfaas/store](https://github.com/openfaas/store) repo for more.

## Logs

Logs are available at the function level via the API.

You can also install a Docker logging driver to aggregate your logs. By default functions will not write the request and response bodies to stdout. You can toggle this behaviour by setting `read_debug` for the request and `write_debug` for the response.

## Tracing

An "X-Call-Id" header is applied to every incoming call through the gateway and is usable for tracing and monitoring calls. We use a UUID for this string.

Header:

```
X-Call-Id
```

Within a function this is available as `Http_X_Call_Id`.

## Environmental overrides
The gateway can be configured through the following environment variables:

| Option                 | Usage             |
|------------------------|--------------|
| `write_timeout`        | HTTP timeout for writing a response body from your function (in seconds). Default: `8`  |
| `read_timeout`         | HTTP timeout for reading the payload from the client caller (in seconds). Default: `8` |
| `functions_provider_url`             | URL of upstream [functions provider](https://github.com/openfaas/faas-provider/) - i.e. Swarm, Kubernetes, Nomad etc  |
| `logs_provider_url` | URL of the upstream function logs api provider, optional, when empty the `functions_provider_url` is used |
| `faas_nats_address`          | The host at which NATS Streaming can be reached. Required for asynchronous mode |
| `faas_nats_port`    | The port at which NATS Streaming can be reached. Required for asynchronous mode |
| `faas_nats_cluster_name` | The name of the target NATS Streaming cluster. Defaults to `faas-cluster` for backwards-compatibility |
| `faas_nats_channel` | The name of the NATS Streaming channel to use. Defaults to `faas-request` for backwards-compatibility |
| `faas_prometheus_host`         | Host to connect to Prometheus. Default: `"prometheus"` |
| `faas_promethus_port`         | Port to connect to Prometheus. Default: `9090` |
| `direct_functions`            | `true` or `false` -  functions are invoked directly over overlay network by DNS name without passing through the provider |
| `direct_functions_suffix`     | Provide a DNS suffix for invoking functions directly over overlay network  |
| `basic_auth`              | Set to `true` or `false` to enable embedded basic auth on the /system and /ui endpoints (recommended) |
| `secret_mount_path`       | Set a location where you have mounted `basic-auth-user` and `basic-auth-password`, default: `/run/secrets/`. |
| `scale_from_zero`       | Enables an intercepting proxy which will scale any function from 0 replicas to the desired amount |
