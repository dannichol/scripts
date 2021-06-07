function print_net() {
  net=$(nmcli connection show | grep -v "\-\-")
  [[ -n $net ]] && status=$(echo $net | cut -d' ' -f7 | tr [a-z] [A-Z]) \
    || unset status
  echo -e "$status "
}

function print_vol() { 
  vol=$(pamixer --get-volume)
  echo -e "Vol:$vol "
}

function print_batt() {
  mains=$(acpi -a | cut -d' ' -f3)
  charge=$(acpi -b | cut -d' ' -f4 | sed 's/,//g')
  [[ $mains = "on-line" ]] && export plug="(charging)" || plug=''
  echo -e "Batt:$charge$plug "
}

function print_date() {
  date=$(date '+%a %d/%m/%y %H:%M')
  echo -e "Date:$date"
}

  echo "$(print_net)$(print_vol)$(print_batt)$(print_date)"
