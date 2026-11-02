#!/bin/sh
# Gera o APK do launcher: baixa o TV Detox na versão testada, aplica o patch deste projeto e compila.
#
# Uso:   scripts/build-launcher.sh
# Saída: build/tvhome.apk
#
# Requer git, Java 17+ e o Android SDK com uma plataforma e build-tools 34 ou 35.
# Variáveis opcionais:
#   ANDROID_HOME   caminho do SDK (padrão: ~/Android/Sdk ou ~/Library/Android/sdk)
#   KEYSTORE       chave de assinatura (.jks). Sem ela, uma chave nova é criada em build/key.jks.
#   KEYSTORE_PASS  senha da chave (padrão: tvhome123)
#
# Para atualizar um launcher já instalado, use a mesma chave da instalação anterior.
set -eu

UPSTREAM=https://github.com/Ansub/tv-detox.git
COMMIT=b22a1e368ee56d670d11115d8408e9025488240b

ROOT=$(cd "$(dirname "$0")/.." && pwd)
PATCH=$ROOT/patches/tv-detox-tvbox-h3.patch
WORK=$ROOT/build/tv-detox

SDK=${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}
if [ -z "$SDK" ]; then
  for d in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk"; do [ -d "$d" ] && SDK=$d && break; done
fi
[ -n "$SDK" ] && [ -d "$SDK" ] || { echo "Android SDK não encontrado. Defina ANDROID_HOME." >&2; exit 1; }

# O build.sh do TV Detox fixa a plataforma e as build-tools 34; usa a 35 quando a 34 não existe.
if [ -f "$SDK/platforms/android-34/android.jar" ] && [ -d "$SDK/build-tools/34.0.0" ]; then
  API=34
elif [ -f "$SDK/platforms/android-35/android.jar" ] && [ -d "$SDK/build-tools/35.0.0" ]; then
  API=35
else
  echo "Instale platforms;android-34 e build-tools;34.0.0 (ou as versões 35)." >&2
  exit 1
fi

rm -rf "$WORK"
mkdir -p "$ROOT/build"
git clone --quiet "$UPSTREAM" "$WORK"
git -C "$WORK" checkout --quiet "$COMMIT"
git -C "$WORK" apply "$PATCH"

if [ -n "${KEYSTORE:-}" ]; then
  KS=$(cd "$(dirname "$KEYSTORE")" && pwd)/$(basename "$KEYSTORE")
else
  KS=$ROOT/build/key.jks
fi

cd "$WORK"
sed -e "s|platforms/android-34/|platforms/android-$API/|" -e "s|build-tools/34.0.0|build-tools/$API.0.0|" build.sh \
  | ANDROID_HOME=$SDK KEYSTORE=$KS KEYSTORE_PASS=${KEYSTORE_PASS:-tvhome123} sh -s

cp out/tvhome.apk "$ROOT/build/tvhome.apk"
echo "APK gerado: build/tvhome.apk"
