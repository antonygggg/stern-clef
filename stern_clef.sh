#!/bin/bash

template_arg_name="template"
has_template=false

for arg in "${@}"; do
  if [[ "$arg" == *"$template_arg_name"* ]]; then
    has_template=true
  fi
done

# add CLEF template
if ! $has_template; then
  # 0=reset
  # 1=bold
  # 4=underline
  # 30-37=normal fg colors
  # 40-47=normal bg colors
  # 90-97=bright fg colors
  # 100-107=bright bg colors

  log_template=""

  # pod name
  pod_name="{{\"\033[1m\"}}{{color .PodColor .PodName}}{{\"\033[0m\"}}"

  log_template+=$pod_name

  # container name
  cont_name="{{\"\033[1m\"}}{{color .ContainerColor .ContainerName}}{{\"\033[0m\"}}"

  log_template+="{{\"\033[1;37m\"}}-{{\"\033[0m\"}}"
  log_template+=$cont_name
  log_template+="{{with \$d := .Message | parseJSON}} "

  # event id @i
  event_id="{{\"\033[1;37m\"}}[{{\"\033[95m\"}}{{index \$d \"@i\"}}{{\"\033[37m\"}}]{{\"\033[0m\"}} "

  log_template+=$event_id

  # level @l
  log_lvl="{{with \$level := index \$d \"@l\"}}"
  log_lvl+="{{\"\033[1;37m\"}}["
  log_lvl+="{{if eq \$level \"Trace\"}}{{\"\033[92m\"}}{{end}}"
  log_lvl+="{{if eq \$level \"Debug\"}}{{\"\033[32m\"}}{{end}}"
  log_lvl+="{{if eq \$level \"Information\"}}{{\"\033[94m\"}}{{end}}"
  log_lvl+="{{if eq \$level \"Warning\"}}{{\"\033[32m\"}}{{end}}"
  log_lvl+="{{if eq \$level \"Error\"}}{{\"\033[91m\"}}{{end}}"
  log_lvl+="{{if eq \$level \"Critical\"}}{{\"\033[31m\"}}{{end}}"
  log_lvl+="{{printf \"%.*s\" 1 \$level}}" # print only the first char from the log level i.e for Debug it will print D
  log_lvl+="{{\"\033[37m\"}}]"
  log_lvl+="{{\"\033[0m\"}}{{end}} "

  log_template+=$log_lvl

  # time @t
  log_time="{{\"\033[1;37m\"}}[{{\"\033[36m\"}}{{index \$d \"@t\"}}{{\"\033[37m\"}}]{{\"\033[0m\"}} "

  log_template+=$log_time

  # message @m
  log_msg="{{\"\033[1;97m\"}}{{index \$d \"@m\"}}{{\"\033[0m\"}} "

  log_template+=$log_msg

  # exception @x
  log_excp="{{if index \$d \"@x\"}}{{\"\n\"}}{{\"\033[39m\"}}{{index \$d \"@x\"}}{{\"\033[0m\"}}{{end}}"

  log_template+=$log_excp
  log_template+="{{end}}{{\"\n\"}}"

  set -- "$@" "--template=${log_template}"
fi

stern "$@"
