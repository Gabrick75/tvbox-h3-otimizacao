# Restauração

A restauração não foi testada.

| Dano | Recuperação |
|---|---|
| Apps ou dados | ADB ou reset de fábrica |
| `/system` ou `boot` | regravar as imagens pelo recovery |
| `bootloader`, `env` ou recovery | exige ferramentas da Allwinner |
| `boot0` ou `boot1` | exige o firmware original da placa |

O H3 tenta o boot pelo cartão SD antes da NAND e tem modo FEL via USB, o que reduz o risco de perda definitiva.

## Observações

- As imagens foram lidas pelo driver de NAND da Allwinner e não podem ser regravadas por um Linux comum.
- As imagens de `system` e `data` são anteriores à limpeza.
- Gravar firmware de outra placa pode impedir o boot pela NAND.
- O reset de fábrica apaga o `/data` e desfaz a limpeza.
