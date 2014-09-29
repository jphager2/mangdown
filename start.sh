name=$1
path=$2

docker run --rm -it -v /home/john/manga:/home/manga \
  --name ruby-irb-mangdown -v $path:/usr/src/app \
  jphager2/ruby-$name
