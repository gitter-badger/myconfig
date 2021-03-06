#!/usr/bin/env bash
# ~/bin/myautosetup.sh
# Last modified: Wed Jun 24, 2015  12:03

#==============================================================================
#===  Global variables  =======================================================
#==============================================================================

#BatPresent=$(acpi -b | wc -l)
ACPresent=$(acpi -a | grep -c on-line)
XRANDR=`xrandr`
DOCKED_OUTPUT="DP2-1"

# DOCKED=$(cat /sys/devices/platform/dock.0/docked)
if [[ $XRANDR == *$DOCKED_OUTPUT\ connected*  ]]; then
  DOCKED=1
else
  DOCKED=0
fi

#==============================================================================
#===  Functions  ==============================================================
#==============================================================================
chooseAudioCard() {
  NUM=$(cat /proc/asound/cards | grep -m1 $1 | cut -d' ' -f2)
  if [[ -z "$NUM" ]]; then
    echo "NUM was empty for $1"
    NUM=1
  fi
  echo "#generated via ~/bin/myautosetup.sh" > ~/.asoundrc
  echo "#Device is: $1" > ~/.asoundrc
  echo "defaults.ctl.card $NUM" >> ~/.asoundrc
  echo "defaults.pcm.card $NUM" >> ~/.asoundrc
  echo "defaults.timer.card $NUM" >> ~/.asoundrc
  # the following needs the package alsaequal 
  if [[ -a "/usr/lib/alsa-lib/libasound_module_ctl_equal.so" ]]; then
    echo "ctl.equal { type equal; }" >> ~/.asoundrc
    echo "pcm.plugequal { type equal; slave.pcm \"plughw:${NUM},0\"; }" >> ~/.asoundrc
    echo "pcm.!default { type plug; slave.pcm plugequal; }" >> ~/.asoundrc
  fi
}

#==============================================================================
#===  Input arguments  ========================================================
#==============================================================================
rotate="normal"
while [ $# -ne 0 ]; do
  case "$1" in
    wait)
      sleep 0.5
      ;;
    rotate)
      shift
      rotate=$1
      ;;
  esac
  shift
done

#==============================================================================
#===  Main part  ==============================================================
#==============================================================================
case "$DOCKED" in
  "0") #=======================================================================
    echo "status is UNDOCKED"
    xset dpms 300 600 900 &

    # DEFAULT_OUTPUT='eDP1'
    # OUTPUTS='DP1 DP2 DP2-1 DP2-2 DP2-3 HDMI1 HDMI2 VIRTUAL1'
    # EXECUTE=""
    # for CURRENT in $OUTPUTS; do
    #   if [[ $XRANDR == *$CURRENT\ connected*  ]]; then # is connected
    #     if [[ $XRANDR == *$CURRENT\ connected\ \(* ]]; then # is disabled
    #       EXECUTE+="--output $CURRENT --auto --above $DEFAULT_OUTPUT "
    #       xset dpms 99997 99998 99999 &
    #     else
    #       EXECUTE+="--output $CURRENT --off "
    #     fi
    #   else # make sure disconnected outputs are off
    #     EXECUTE+="--output $CURRENT --off "
    #   fi
    # done
    # xrandr --output $DEFAULT_OUTPUT --primary --auto $EXECUTE
    xrandr --output VIRTUAL1 --rotate normal --off \
           --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP1 --rotate normal --off \
           --output DP2-1 --rotate normal --off \
           --output DP2-2 --rotate normal --off \
           --output DP2-3 --rotate normal --off \
           --output HDMI2 --rotate normal --off \
           --output HDMI1 --rotate normal --off \
           --output DP2 --rotate normal --off
    [[ $ACPresent == "0" ]] && { xbacklight =70 & } || { xbacklight =100 & }

    sudo /usr/bin/rfkill unblock all &

    (
      sleep 1
      chooseAudioCard "PCH"
      amixer -q set Master off
    )&
    ;;
  "1") #=======================================================================
    echo "status is DOCKED"
    xset dpms 900 1800 2700 &

    if [[ -a "/tmp/myMonitorConfig1" ]]; then
      /usr/bin/xrandr \
        --output $DOCKED_OUTPUT --primary --mode 1920x1080 --rotate "$rotate" \
        --output eDP1 --mode 1920x1080 --left-of DP2-1
      xbacklight =100 &
      rm /tmp/myMonitorConfig1
      # [[ -f ~/.icc/x230.icc ]] && xcalib -s 0 ~/.icc/x230.icc &
    else
      # /usr/bin/xrandr --output DP2-1 --mode 1920x1080 --output eDP1 --off
      /usr/bin/xrandr \
        --output eDP1 --mode 1920x1080 \
        --output $DOCKED_OUTPUT --mode 1920x1080 --same-as eDP1 --rotate normal
      xbacklight =1 &

      #Error - unsupported ramp size 0
      #[[ -f ~/.icc/23.icc ]] && xcalib ~/.icc/23.icc &
      xset dpms 99997 99998 99999 &
      touch /tmp/myMonitorConfig1
      chmod 777 /tmp/myMonitorConfig1 # Thats ugly :(
    fi

    sudo /usr/bin/rfkill block all &
    (
      sleep 1
      chooseAudioCard "Device"
    )&
    ;;
esac

# setxkbmap -layout de,de -variant neo,nodeadkeys\
#   -option grp:shifts_toggle -option grp_led:scroll\
#   -option altwin:swap_lalt_lwin

feh --bg-center "/home/mhuber/Bilder/background/BACKGROUND.png"
