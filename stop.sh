name=$1
path=$2

app_id=$( \
  docker ps -a | grep $name | \
  ruby -e 'input = $stdin.gets; puts input[0..11] if input' \
)

if [ "$app_id" != '' ]
then
  # Stop and Remove the Rails Server Container
  docker stop $app_id
  docker rm $app_id

  # Change permissions for dirs and files in /home/manga 
  docker run --rm -v /home/john/manga:/home/manga  \
    -w /home/manga jphager2/ruby-$name chmod a+rw /home/manga/**/* 

  echo "ServerID: $app_id"
  echo "Ruby App has stopped: $name"
else
  echo "The Ruby App did NOT stop correctly"
fi


