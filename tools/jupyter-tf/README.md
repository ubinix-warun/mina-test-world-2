
```
conda info --envs
conda activate py310-web-scraping

pip install pipenv
pipenv install jupyter

docker buildx build --platform linux/amd64  -t jupyter-tf:v2 --load .
# docker build -t jupyter-tf:v2 .

docker run --rm -v `pwd`:/app/prj \
    -v ~/.aws:/root/.aws \
    -p 8888:8888 \
    -it jupyter-tf:v2

```