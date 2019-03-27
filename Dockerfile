FROM golang:latest as builder
WORKDIR /go/src/github.com/zate/files 
RUN go get -u github.com/golang/dep/cmd/dep
COPY files.go .
RUN dep init && dep ensure
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o files .

FROM scratch
WORKDIR /home/files
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/github.com/zate/files/files .
EXPOSE 8100
CMD ["./files"]
