FROM julia:1.9

WORKDIR /app
COPY . /app

EXPOSE 8000
EXPOSE 514

RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.test()'


# docker build -t julia-logger .
# docker run -p 8000:8000 -p 514:514 julia-logger