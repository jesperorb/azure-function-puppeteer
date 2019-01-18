# Azure Function - Puppeteer (Docker)

## Build

```bash
docker build -t auto-audit:latest .
```

## Run

```
docker run --rm -it -p 80:80/tcp -e AzureWebJobsStorage="your connection string" auto-audit:latest
```

Get trace like this:
```
http://localhost/api/audit?url=https://dn.se
```

## Links

* https://markheath.net/post/azure-functions-docker
* https://github.com/estruyf/azure-function-node-puppeteer
* https://michaljanaszek.com/blog/test-website-performance-with-puppeteer
* https://www.aymen-loukil.com/en/blog-en/google-puppeteer-tutorial-with-examples/
* https://github.com/projectkudu/kudu/wiki/Azure-runtime-environment
* https://stackoverflow.com/questions/39218895/azure-functions-nodejs-what-are-restrictions-limitations-when-using-file-sys
* https://github.com/Azure/azure-functions-docker/issues/35#issuecomment-438635593
* https://github.com/Googlechrome/puppeteer/issues/290#issuecomment-322921352