### Instalação

```bash
cd fraud-risk-checker
  sh devops/chmod.sh
  ./devops/environment/setup.sh
  ./devops/docker_compose/config.sh
  ./devops/docker_compose/build.sh
  ./devops/docker_compose/up.sh
  ./devops/docker_compose/exec.sh app bash
    cat /etc/hosts | grep dockerhost
    echo > /dev/tcp/dockerhost/5432 && echo "Postgresql is running"
    echo > /dev/tcp/dockerhost/6379 && echo "Redis is running"
    git status
    exit
  ./devops/docker_compose/down.sh
  exit
```

### Desenvolvimento

- Abrir terminal

```bash
cd fraud-risk-checker
  ./devops/docker_compose/up.sh
  ./devops/docker_compose/exec.sh app bash
    bundle

    rails db:drop db:create db:migrate db:seed
    rails c
      Redis.new(url: ENV['HOST_REDIS']).keys
      exit

    ./devops/rails/server.sh
    exit
  ./devops/docker_compose/down.sh
  exit
```
