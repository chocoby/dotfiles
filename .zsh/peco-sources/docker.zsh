function peco-rm-docker-ps () {
  docker rm `docker ps -a  --format "{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Command}}\t{{.RunningFor}}" | peco | awk '{ print $1 }'`
}

function peco-rm-docker-images () {
  docker rmi `docker images  --format "{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"  | peco | awk '{ print $3 }'`
}
