#!/bin/bash
# Compara a configuracao original (A) com a ajustada (B) em 6 rodadas alternadas.
# Altera ajustes temporarios e abre apps na box. Termina na configuracao B.
OUT=${1:?uso: teste-io.sh ARQUIVO_DE_SAIDA}
setio(){ adb shell "for b in nandd nandn; do echo $2 > /sys/block/\$b/queue/scheduler; echo $3 > /sys/block/\$b/queue/rotational; echo $4 > /sys/block/\$b/queue/read_ahead_kb; done" </dev/null; }
drop(){ adb shell 'sync; echo 3 > /proc/sys/vm/drop_caches' </dev/null; }
temp(){ adb shell cat /sys/class/thermal/thermal_zone0/temp </dev/null | tr -d '\r'; }
YT=$(adb shell cmd package resolve-activity --brief -c android.intent.category.LEANBACK_LAUNCHER -a android.intent.action.MAIN com.google.android.youtube.tv </dev/null | tail -1 | tr -d '\r')
case "$YT" in *youtube*) ;; *) YT=com.google.android.youtube.tv/com.google.android.apps.youtube.tv.activity.ShellActivity;; esac
echo "YT=$YT"
APK=$(adb shell pm path com.stremio.one </dev/null | head -1 | sed 's/package://' | tr -d '\r')
APK=$(dirname "$APK")/base.apk
coldstart(){ pkg=${1%%/*}; adb shell am force-stop $pkg </dev/null; drop; sleep 2
  t=$(adb shell am start -W -n $1 </dev/null | tr -d '\r' | grep -E '^TotalTime' | cut -d' ' -f2); sleep 3
  adb shell input keyevent KEYCODE_HOME </dev/null; adb shell am force-stop $pkg </dev/null; sleep 2; echo "$t"; }
r=0
for cfg in A B A B A B; do r=$((r+1))
  if [ $cfg = A ]; then setio x cfq 1 32; else setio x deadline 0 256; fi
  drop
  dd=$(adb shell "dd if=$APK of=/dev/null bs=1048576 2>&1 | tail -1" </dev/null | tr -d '\r' | grep -oE '[0-9]+ bytes/sec|[0-9.]+ [KM]?B/s|\([0-9]+ bytes/sec\)' | grep -oE '[0-9]+' | head -1)
  s=$(coldstart com.android.settings/.Settings)
  y=$(coldstart "$YT")
  T=$(temp)
  echo "$r $cfg dd=$dd settings=$s youtube=$y temp=$T" | tee -a "$OUT"
done
