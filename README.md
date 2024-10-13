# urls

Returns a list of URLs.

## Develop

Start

```bash
overman start

# in docker
bin/docker-run
```

Test

```bash
bin/test

# in docker
docker run --rm -it -e PORT=8080 $(docker build . -q) bin/test
```
## Deploy

```bash
git push # to github
```

## Example usage

https://urls.fly.dev/?url=googleonlinesecurity.blogspot.se
