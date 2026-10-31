# Desempenho

## Diagnóstico

| Área | Medição |
|---|---|
| RAM | 440 MB livres em repouso; zram praticamente sem uso |
| CPU | 1,008 GHz, com desligamento automático de núcleos |
| Temperatura | 75–78 °C em repouso; até 92 °C após o boot |
| NAND | 26 MB/s de leitura; `cfq`, `rotational=1`, read-ahead de 32 KB |

Sob carga, a box atinge 85 °C em cerca de 10 s e passa de 4 para 3 núcleos.

## Teste A/B

| Configuração | Escalonador | `rotational` | `read_ahead_kb` |
|---|---|---|---|
| A (original) | `cfq` | 1 | 32 |
| B (ajustada) | `deadline` | 0 | 256 |

Cada rodada limpa o cache e mede a leitura de um APK e a abertura a frio de dois apps. Foram 6 rodadas alternadas
([script](../scripts/teste-io.sh), [dados](../resultados/teste-io.txt)).

| Métrica | A | B | Variação |
|---|---|---|---|
| Leitura | 24,7 MB/s | 26,6 MB/s | +8% |
| Configurações | 1.537 ms | 1.431 ms | −7% |
| YouTube | 1.306 ms | 1.020 ms | −22% |

O resultado do YouTube é consistente entre as rodadas; o das Configurações tem sobreposição. O tempo vai até o primeiro
quadro exibido.
