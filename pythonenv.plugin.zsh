() {
  local plugin_dir
  plugin_dir=$(dirname $(print -P %x))
  MKENV_STANDARD_PATH=${MKENV_STANDARD_PATH:-$plugin_dir/standard}
}

function mkenv {
  local envpath=${1:-.} error env_error leave_error

  mkdir -p $envpath || error=1
  ln -s $MKENV_STANDARD_PATH/.env $envpath/.env || { error=1; env_error=1; }
  ln -s $MKENV_STANDARD_PATH/.env.leave $envpath/.env.leave || { error=1; leave_error=1; }
  
  if [[ -n $error ]]; then
    [[ $env_error ]] || rm $envpath/.env
    [[ $leave_error ]] || rm $envpath/.env.leave
    echo 'Error creating environment.' >&2
  else
    builtin cd $envpath
    source .env
  fi
}

