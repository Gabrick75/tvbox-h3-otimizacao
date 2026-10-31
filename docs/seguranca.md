# Segurança

## Achados

- Apps instaladores criavam sessões de instalação sem ação do usuário (`/data/system/install_sessions.xml`).
- `/system/bin/preinstall.sh` inicia `/system/bin/qw` como root a cada boot. As strings do binário indicam um `su`
  derivado do [Superuser](https://github.com/koush/Superuser).
- O SuperSU também vem instalado de fábrica.

`qw`, SHA-256: `2035e57a5cf020ae2ac7d1f7cfd3cb30e139db859ae856eaf166a08213f99307`

## Estado após a limpeza

Os apps instaladores de terceiros foram removidos e não voltaram após reinícios. Permanecem no `/system`:

- `com.uv.droid.uota` e `com.uv.droid.uotaback`, desativados;
- SuperSU e `qw`;
- APKs em `/system/preinstall`.

## Recomendações

- Use rede de convidados e uma conta Google exclusiva.
- Não use a box para dados sensíveis.
- Não abra pacotes de fábrica, como `com.softwinner.agingdragonbox`.
- Nunca publique o backup: ele contém dados de conta e a rede Wi-Fi salva.
