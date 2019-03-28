FROM golang:latest as builder
WORKDIR /go/src/github.com/zate/files 
COPY files.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o files .

FROM scratch
WORKDIR /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/github.com/zate/files/files .
EXPOSE 8100
CMD ["./files"]
