# Mapa de Boras no Flutter

A Home usa `MapSection`, com pins de Halloween de 42 × 48 e calor calculado somente a partir de `boraCount`. Os filtros, a assinatura pública e sua renovação a cada minuto permanecem no fluxo existente da Home.

## Renderização

`map_heat.dart` separa agregação, raster RGBA e adaptação ao SDK. O domínio já usa contagens inteiras. Coordenadas inválidas e contagens não positivas são descartadas antes da projeção. A cor é escolhida depois da soma por coordenada exata. O buffer auxiliar usa Float32 e a sobreposição escolhe a maior força.

A integração utiliza TileOverlay do Google Maps, abaixo dos marcadores nativos. Cada tile é calculado em resolução reduzida por quatro e ampliado com interpolação, incluindo margem de um pixel para as bordas. O raio é compensado pela diferença entre o zoom do tile e o zoom atual da câmera. Mudanças de contadores, filtros ou zoom substituem o identificador da camada, invalidando os tiles anteriores. Pan e redimensionamento são gerenciados pelo SDK. Não há consultas de usuários para desenhar o calor.

Os pins são uma transcrição Canvas dos paths SVG da referência, rasterizada por densidade, com cache por contagem e densidade durante a vida do mapa. Não usam geração de imagem por IA. Antes do bitmap estar pronto, o marcador fica invisível para evitar flashes do pin padrão.

## Diferenças deliberadas e limites

- A câmera é preservada quando somente contadores/conteúdo mudam; coordenadas dos pins ou localização alteradas reaplicam o enquadramento.
- A seleção desaparece quando o grupo deixa de existir ou passa a ter apenas um item.
- O timeout de 30 segundos cobre a espera até o primeiro idle, como proteção adicional do adaptador Flutter; não é o timeout exclusivo do carregador JavaScript.
- Rotação e inclinação estão desativadas para preservar manchas circulares no plano da tela.
- O raster usa uma grade fixa de tiles, em vez da grade relativa ao viewport do canvas React. A suavização pode diferir em subpixels; durante zoom animado o SDK pode exibir tiles anteriores até os novos ficarem prontos. Não se afirma paridade byte a byte com o canvas web.
- A configuração ausente da chave web continua sendo tratada pela Home. O SDK não fornece neste fluxo uma notificação universal de falha de autorização ou de tiles.

## Verificação

Os testes cobrem soma de eventos vinculados e independentes, exclusão de check-ins, coordenadas inválidas, limites das faixas, alpha, sobreposição, PNG dos tiles, dimensões dos pins em três densidades e estados/navegação da Home. Os testes de widgets usam um adaptador de mapa falso; ainda é necessário comparar em Android/iOS/web com credenciais reais a ordem das camadas, pan, zoom fracionário, bordas dos tiles e acessibilidade com leitor de tela.
