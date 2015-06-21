#!/bin/sh

config_dir="$HOME/.conky"

conky -c ${config_dir}/system.conkyrc &
conky -c ${config_dir}/weather.conkyrc &
