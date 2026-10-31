# Linux na NAND

Não recomendado.

| Opção | Situação |
|---|---|
| Linux mainline na NAND | sem suporte a boot pela NAND; a NAND MLC é o principal obstáculo |
| Armbian legado (kernel 3.4) | depende de driver proprietário e tem relatos de falha |
| Debian sobre o kernel 4.4 da box | possível, mas remove o Android e mantém um kernel sem atualizações |

A NAND lê a 26 MB/s, desempenho próximo ao de um bom cartão SD. As alternativas são:

1. Cartão microSD A1 ou A2.
2. Boot pelo SD e sistema em SSD ou pendrive USB.

## Fontes

- [linux-sunxi: NAND](https://linux-sunxi.org/NAND)
- [Armbian: H3 com NAND de 8 GB](https://forum.armbian.com/topic/22486-h3-1gb-ram-8gb-nand-armbian-working-but-cannot-install-to-nand)
- [Armbian: NAND boot](https://forum.armbian.com/topic/5793-nand-boot/)
- [linux-sunxi, lista de discussão: MLC e SLC](https://yhbt.net/lore/all/20210728141644.xgcldm2vyjbembyw@gilmour/)
- [linux-mtd: DMA para o H3](https://lists.infradead.org/pipermail/linux-mtd/2020-October/082826.html)
