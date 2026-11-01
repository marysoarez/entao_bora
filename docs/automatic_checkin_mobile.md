# Etapa 13 — Check-in automático mobile

O check-in automático é opt-in e independente do compartilhamento comum de localização. A tela Minha Área apresenta um consentimento específico antes de ativar o monitor. Revogar o consentimento cancela o stream; logout também interrompe o monitor.

## Decisão de presença

O app consulta somente estabelecimentos com `autoCheckinSettings.autoCheckinEnabled == true` e reutiliza `address.latitude`/`address.longitude`. Leituras com precisão pior que 50 m são ignoradas. A entrada exige que distância mais a margem de precisão permaneça dentro do raio durante `minimumStayMinutes`; uma passagem rápida reinicia a candidatura.

A saída usa raio com tolerância de 1,5 vez, desconta a margem de precisão e exige permanência fora pelo mesmo período mínimo. Um cooldown de 30 minutos impede alternância imediata após transições. Esses limites operacionais estão isolados em `AutoCheckinPolicy` para calibração futura.

No Android o stream usa intervalo de um minuto, deslocamento mínimo de 50 m e serviço foreground sem wake lock. No iOS permite atualizações em background, indicador visível e pausa automática do sistema. Os manifests incluem as descrições e permissões correspondentes.

## Persistência

O app reutiliza `places/{placeId}/checkins/{uid}`. Check-in geofence cria ou complementa a presença; check-out preenche `checkedOutAt`. Não cria mesa, `ServiceSession`, participante ou pedido. As regras exigem conta ativa, UID próprio e `autoCheckinConsentEnabled: true` para gravações geofence.

## Validação

Os testes puros simulam entrada, permanência, GPS impreciso, passagem rápida, histerese de saída e checkout. A suíte Flutter completa e a análise dos arquivos alterados devem passar antes da publicação. Consumo real de bateria e entrega em background precisam ser medidos em aparelhos Android e iOS físicos, pois simuladores e testes unitários não reproduzem suspensão, fabricantes Android ou políticas do iOS.

Nenhum deploy foi executado.
