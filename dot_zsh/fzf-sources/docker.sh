fzf_rm_docker_ps () {
  docker rm `docker ps -a  --format "{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Command}}\t{{.RunningFor}}" | fzf | awk '{ print $1 }'`
}

fzf_rm_docker_images () {
  docker rmi `docker images  --format "{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"  | fzf | awk '{ print $3 }'`
}

zle -N fzf_rm_docker_ps
zle -N fzf_rm_docker_images
