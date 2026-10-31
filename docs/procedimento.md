# Procedimento

Os passos com `/system` exigem root.

## 1. Backup

Copie cada partição listada em `/dev/block/by-name` e confira o MD5:

```sh
adb exec-out "dd if=/dev/block/by-name/boot 2>/dev/null | gzip -c" > boot.img.gz
```

`boot0` e `boot1` não ficam expostas e não entram no backup.

## 2. Remoção de apps

Desative em lotes, um pacote por comando ([listas](../listas/)):

```sh
adb shell pm disable-user --user 0 PACOTE
```

Para liberar espaço, desinstale os apps de terceiros já desativados:

```sh
adb shell pm uninstall PACOTE
```

Após desinstalar, confira `/data/app` e reinicie. Em um caso, `pm uninstall` retornou `Success` sem remover a pasta do app.

## 3. Launcher

Aplique o patch ao código do TV Detox e siga as instruções de build daquele projeto:

```sh
git apply patches/tv-detox-sem-servico-de-entradas.patch
```

O patch evita a falha de `getTvInputList()` em aparelhos sem serviço de entradas de TV.

## 4. Kodi e localização

```sh
K=/data/media/0/Android/data/org.xbmc.kodi/files/.kodi/userdata
adb shell am force-stop org.xbmc.kodi
adb shell "rm -rf $K/Thumbnails/*; rm -f $K/Database/Textures13.db"

adb shell settings put secure location_providers_allowed -gps
adb shell settings put secure location_providers_allowed -network
```

## 5. Ajuste de I/O

Teste temporário:

```sh
scripts/aplicar-io.sh            # aplica
scripts/aplicar-io.sh desfazer   # reverte
```

Instalação permanente:

```sh
adb push config/io-tuning.rc /data/local/tmp/
adb shell '/sbin/busybox mount -o remount,rw /system
cp /data/local/tmp/io-tuning.rc /system/etc/init/
chown root:root /system/etc/init/io-tuning.rc
chmod 644 /system/etc/init/io-tuning.rc
restorecon /system/etc/init/io-tuning.rc
sync
/sbin/busybox mount -o remount,ro /system
rm /data/local/tmp/io-tuning.rc'
```

Antes de instalar, confirme que o `fstab` não usa `verify`. Use o `mount` do BusyBox: o da box falha com "Device or resource busy".

Remoção:

```sh
adb shell '/sbin/busybox mount -o remount,rw /system; rm /system/etc/init/io-tuning.rc; sync; /sbin/busybox mount -o remount,ro /system'
adb reboot
```

## 6. Verificação

Após reiniciar:

```sh
adb shell 'for b in nandd nandn; do
  echo "$b $(grep -o "\[[a-z]*\]" /sys/block/$b/queue/scheduler) rot=$(cat /sys/block/$b/queue/rotational) ra=$(cat /sys/block/$b/queue/read_ahead_kb)"
done'
```

Saída esperada: `[deadline] rot=0 ra=256` nas duas partições.
