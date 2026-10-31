#!/bin/sh
# Reaplica o ajuste de leitura da NAND na TV box. Precisa rodar de novo a cada reboot.
# Original: ./aplicar-io.sh desfazer  (ou apenas reiniciar a box)
if [ "$1" = "desfazer" ]; then
  sch=cfq; rot=1; ra=32
else
  sch=deadline; rot=0; ra=256
fi
adb shell "for b in nandd nandn; do
  echo $sch > /sys/block/\$b/queue/scheduler
  echo $rot > /sys/block/\$b/queue/rotational
  echo $ra > /sys/block/\$b/queue/read_ahead_kb
  echo \"\$b: \$(cat /sys/block/\$b/queue/scheduler | tr -d '[]') ativo=\$(grep -o '\[[a-z]*\]' /sys/block/\$b/queue/scheduler) rot=\$(cat /sys/block/\$b/queue/rotational) ra=\$(cat /sys/block/\$b/queue/read_ahead_kb)\"
done"
