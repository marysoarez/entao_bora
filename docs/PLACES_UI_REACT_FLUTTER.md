# Estabelecimentos — referência visual e comportamental React → Flutter

Referência: código local em 16/09/2026, incluindo alterações presentes no diretório de trabalho. Escopo principal: detalhe público em `/place/{id ou slug}`, dentro do `Shell`. Criação, edição, gestão e cardápio administrativo fazem parte do escopo de migração geral em [MIGRACAO_REACT.md](MIGRACAO_REACT.md); o card resumido da Home está em [HOME_REACT_FLUTTER.md](HOME_REACT_FLUTTER.md).

Esta especificação foi conferida no código React e comparada com a implementação Flutter atual. Não houve validação ponta a ponta com Firebase, links externos ou navegador real. Medidas são declarações CSS, salvo indicação contrária.

## 1. Onde a interface é construída

| Fonte | Responsabilidade |
| --- | --- |
| `react-web/src/features/places/pages/PlaceDetailsPage.tsx` | Entrada da rota; delega ao detalhe compartilhado. |
| `react-web/src/features/entity-detail/EntityDetails.tsx` | Consulta, apresentação, cardápio, horários, eventos, ações e metadata. |
| `react-web/src/features/events/components/EventCard.tsx` | Cards dos próximos eventos. |
| `react-web/src/app/App.tsx` | Cabeçalho, container e rodapé globais. |
| `react-web/app/globals.css` | Identidade, medidas e breakpoint de 760 px. |
| `react-web/src/core/repository.ts` | Resolução por ID/slug e assinatura dos próximos eventos. |
| `react-web/src/shared/domain.ts` | Imagens, moeda, URLs e autorização. |
| `react-web/src/shared/models.ts` | Place, MenuItem, OpeningHours, Address e gêneros. |

Equivalentes Flutter atuais:

| Fonte | Responsabilidade atual |
| --- | --- |
| `lib/feature/places/presentation/pages/place_details_page.dart` | Entrada por ID/slug, compartilhamento, menu e composição. |
| `place_hero.dart`, `place_about.dart`, `place_actions.dart` | Hero, descrição e atalhos. |
| `place_menu_sheet.dart`, `public_menu_item_tile.dart` | Cardápio em bottom sheet. |
| `place_events_section.dart` | Próximos eventos. |
| `place_owner_section.dart` | Responsável e edição. |
| `place_details_skeleton.dart` | Skeleton Flutter. |
| `place_details_viewmodel.dart`, `place_events_viewmodel.dart` | Consulta e eventos associados. |

## 2. Rota, shell e composição

- Rota pública React: `/place/:id`; o parâmetro aceita ID ou slug.
- O detalhe aparece dentro do Shell compartilhado: cabeçalho, container central e rodapé.
- O container tem largura máxima 1200 px e padding 48/0/60 acima de 1250, 36/28/50 entre 761 e 1250 e 30/18/30 até 760.
- A página inteira rola; cabeçalho, aside e rodapé não são fixos.

Ordem vertical:

```text
Cabeçalho global
Container
  ← Voltar para explorar
  Foto principal, quando existe
  Grade de detalhes
    Artigo principal
      Gêneros
      Nome
      Endereço
      Sobre o lugar
      Galeria secundária
      Cardápio
      Horários, quando existem
      Próximos eventos
    Aside
      Planeje sua visita
      Telefone, quando existe
      Site, quando válido
      Como chegar
      Compartilhar
      Editar, quando autorizado
      Mensagem de erro ou confirmação
Rodapé global
```

O React não mostra na página pública: tipo do estabelecimento, Instagram, responsável/proprietário, `menuCategories` isoladamente ou botão de ligação. Alguns desses itens aparecem no Flutter atual e constituem diferenças.

## 3. Identidade visual

### Cores

| Uso | Valor |
| --- | --- |
| Fundo | `#000000` |
| Texto | `#F6F4F2` |
| Parágrafos | `#AAAAAA` |
| Texto sutil | `#777777` |
| Vermelho principal | `#D64545` |
| Aside, cardápio, horários e mensagens | `#161616` |
| Chips | `#222222` |
| Bordas do aside e itens | `#333333` |
| Borda da mensagem | `#353535` |
| Link em mensagem | `#EF8888` |

Superfícies são planas e sem elevação. O aside tem borda de 1 px. Os blocos `<details>` não têm borda explícita no React.

### Tipografia

- Família Arial, fallback Helvetica e sans-serif.
- Nome do estabelecimento: 40 px desktop / 32 px mobile, peso 700 e tracking `-0.045em`.
- Títulos de seção: 26 px, peso 700 e tracking `-0.045em`.
- Título de item do cardápio: 19 px.
- Chips: 11 px.
- Parágrafos: `#AAA`, altura 1,65 e margem vertical 8.
- Textos `subtle`: 11 px e `#777`.
- O aside usa os tamanhos herdados, com gap 15 entre elementos.

O Flutter inclui Arimo como fallback métrico de Arial. Comparar quebras com a mesma fonte, escala e largura lógica.

## 4. Layout e responsividade

| Propriedade | Acima de 760 px | Até 760 px |
| --- | --- | --- |
| Foto principal | Altura 360; raio 14 | Altura 240; raio 14 |
| Grade | Artigo flexível + aside 320; gap 40 | Uma coluna; gap 20 |
| Margem da grade | 28 | 28 |
| Nome | 40 px | 32 px |
| Galeria | Horizontal e rolável | Horizontal e rolável |
| Próximos eventos | Grid global de 3 colunas, gap 22 | Uma coluna, gap 22 |

- A foto principal usa largura total e `object-fit: cover`.
- Se `photos` estiver vazia, a foto principal não existe; o nome passa a seguir o link de volta e a margem da grade.
- Não há layout específico de duas colunas no tablet para os cards de evento; o grid continua com três colunas até 761 px.
- O aside vai para baixo de todo o artigo no mobile.
- Não há truncamento explícito de nome, descrição, endereço ou itens de cardápio.

## 5. Foto, gêneros, nome e endereço

### Foto principal

- Fonte: `place.photos[0]`.
- Aceita HTTP(S), Data URI ou Base64 puro via `imageSource()`.
- Alt: nome do estabelecimento.
- Dimensões: 360/240 conforme breakpoint, largura total, `cover`, raio 14.
- Sem primeira foto: elemento omitido, sem placeholder.
- Erros de carregamento não possuem fallback explícito no React.

### Gêneros

- Todos os gêneros são mostrados antes do nome.
- Flex com quebra, gap 8 e margem vertical 16.
- Chip: `#222`, padding 7 × 11, raio 20, fonte 11.
- Valores desconhecidos são lidos como `other` e exibidos como `Outro`.
- Lista vazia simplesmente não produz chips; o container ainda existe sem conteúdo útil.

### Nome e endereço

- Nome completo em `h1`.
- Endereço em parágrafo: Lucide `MapPin` 16 + `address.displayName`.
- Não há link para mapa no endereço; `Como chegar` fica no aside.
- O campo `type` não aparece neste detalhe React.

## 6. Sobre e galeria

### Sobre

- Título: `Sobre o lugar`, com margem superior inline 32.
- Descrição usa `white-space: pre-wrap`, preservando quebras.
- Não há “leia mais”, limite de linhas ou enriquecimento de links.

### Galeria

- Usa `place.photos.slice(1)`: a primeira foto fica reservada à capa e não se repete.
- Preserva a ordem armazenada.
- Linha flex horizontal, gap 15, `overflow: auto`, margem vertical 25.
- Imagens 180 × 130, `cover`, raio 8 e lazy loading.
- Alt: `Foto {1..N} de {nome}`; o índice reinicia em 1 para a primeira foto secundária.
- Com zero ou uma foto, não há mensagem de galeria vazia.

## 7. Cardápio

- O bloco sempre aparece, mesmo sem itens.
- Elemento `<details>` inicialmente fechado.
- Summary: `Cardápio · {nome}`.
- Container: padding 18, fundo `#161616`, raio 10 e margem vertical 18.
- Summary usa cursor pointer e peso 700; o indicador aberto/fechado é o marcador nativo do navegador.

Com itens:

| Parte | Apresentação |
| --- | --- |
| Ordem | Ordem de `menuItems` no documento; sem agrupamento ou ordenação adicional. |
| Linha | Padding vertical 16, borda inferior `#333`, flex com distribuição entre extremos e gap 20. |
| Categoria | `<small>`, valor normalizado para `Geral` quando vazio na leitura. |
| Nome | `h3`, 19 px, peso 700. |
| Descrição | Parágrafo `#AAA`. |
| Preço | `<strong>` à direita, `pt-BR`, moeda BRL. |
| Foto | Não é exibida no React. |

Sem itens: `Cardápio ainda não disponível.`

Diferença atual do Flutter: abre um `DraggableScrollableSheet` com altura inicial 78%, mínima 42%, máxima 94%; agrupa por categoria e mostra foto 86 × 86. Para paridade React, usar bloco expansível inline, manter a ordem plana e omitir fotos. Manter o sheet deve ser registrado como decisão de produto.

## 8. Horários de funcionamento

- O bloco só aparece quando `openingHours.length > 0`.
- `<details>` inicialmente fechado, summary `Horários de funcionamento`.
- Cada item vira um parágrafo, na ordem armazenada.
- Mapeamento: monday Segunda, tuesday Terça, wednesday Quarta, thursday Quinta, friday Sexta, saturday Sábado, sunday Domingo.
- Hora e minuto usam dois dígitos.
- Formato: `{dia}: HH:MM às HH:MM`.
- Não agrupa horários iguais, não indica “aberto agora” e não possui estado “fechado”.
- Dias desconhecidos geram label `undefined` no código atual; validar dados antes de transportar isso.

## 9. Próximos eventos

- Título: `Próximos eventos`.
- Ao carregar o Place, `watchPublic` assina todos os locais e os eventos públicos futuros; a tela ignora o conjunto de locais e filtra eventos com `event.placeId === place.id`.
- A consulta de eventos usa `status == published`, `endDate >= Timestamp.now()` e ordenação por **término**.
- A consulta é recriada a cada minuto para atualizar o limite temporal.
- O filtro local não reordena: mantém a ordem por término vinda da assinatura.
- Cards usam o mesmo `EventCard` da Home: três colunas até 761, uma coluna até 760, capa 210, badge, data inicial, título, local e até dois gêneros.
- Sem eventos: parágrafo `Nenhum evento anunciado no momento.`
- Não existe skeleton específico na seção; durante o carregamento inicial do Place, a página inteira ainda está no estado `Carregando detalhes…`. Depois disso, a assinatura começa com lista vazia e pode exibir brevemente a mensagem vazia antes do primeiro snapshot.
- Erro da assinatura mantém a lista anterior e aparece no aside; a seção não mostra erro local.

Diferença atual do Flutter: `PlaceEventsSection` usa lista vertical de `EventMiniCard`, spinner próprio, mensagem `Nenhum evento encontrado.` e consulta por início no repositório. Igualar o React exige grid e estados/textos correspondentes.

## 10. Aside: visita, links e compartilhamento

### Planeje sua visita

- Título fixo: `Planeje sua visita`.
- Telefone: aparece como parágrafo de texto bruto apenas quando não vazio. Não é link `tel:`.
- Website: aparece como `Visitar site ↗` apenas quando `safeUrl()` aceita HTTP ou HTTPS.
- Instagram não é mostrado.
- Valores inválidos de website são omitidos silenciosamente.

### Como chegar

- Sempre presente.
- URL: `https://www.google.com/maps/search/?api=1&query={latitude},{longitude}`.
- Nova aba e `rel="noreferrer"`.
- Usa coordenadas; não usa o endereço textual.

### Compartilhar

- Botão outline com Lucide `Share2` 16.
- URL: base pública configurada ou origin atual + `/place/{slug ou id}`.
- Web Share recebe `{title: place.name, url}`.
- Sem Web Share, copia o link e mostra `Link copiado!` no aside.
- Diferente de eventos, compartilhar um local não incrementa contador.
- `AbortError` é ignorado; outros erros aparecem no aside.

### Editar

- `Editar informações` → `/places/{entity.id}/edit`.
- Usa ID real após resolução por slug.
- Visível para conta ativa quando `ownerId == user.id`, ou parceiro ativo cujo `partnerId` não vazio coincide com `ownerId`.
- Papel admin não concede edição automaticamente nessa função.

## 11. Estados

| Estado | React atual |
| --- | --- |
| Carregamento inicial | Message `Carregando detalhes…`; não há skeleton. |
| Firebase sem configuração | `Os detalhes estarão disponíveis após conectar a agenda.` + link. |
| ID/slug não encontrado | `Não encontramos este registro.` + link. |
| Falha inicial | Mensagem da exceção + `Explorar outros rolês`. |
| Sem capa | Capa omitida. |
| Sem galeria | Nenhuma mensagem. |
| Sem cardápio | Details com `Cardápio ainda não disponível.` |
| Sem horários | Bloco omitido. |
| Sem próximos eventos | `Nenhum evento anunciado no momento.` |
| Erro dos próximos eventos | Conteúdo existente permanece; Message no aside. |
| Link copiado | Message `Link copiado!` no aside. |
| Erro de imagem | Sem fallback explícito. |

Message: padding 24, margem vertical 20, fundo `#161616`, borda `#353535`, raio 10, texto `#CCC`; links `#EF8888` sublinhados.

O React resolve por ID e depois por slug, sem filtro de publicação/status para locais. As regras do banco continuam determinando o que realmente pode ser lido.

## 12. Metadados e ciclo de vida

- Título configurado como ``{place.name} ? Ent?o Bora`` no código local. Os `?` são caracteres literais resultantes de codificação incorreta e devem ser corrigidos.
- Descrição: `place.description`.
- Imagem: `place.photos[0]` passada por `safeUrl`; Base64 puro não se torna URL de metadata.
- Ao desmontar, metadata padrão é restaurada; ela também contém caracteres corrompidos no código atual.
- A consulta inicial usa flag `alive` para não atualizar estado após desmontagem.
- A assinatura dos eventos é cancelada e seu timer é limpo ao desmontar ou trocar Place.
- Trocar o parâmetro limpa entidade, erro e estado do local associado antes da nova resolução.

## 13. Paridade Flutter

O Flutter atual é visual e funcionalmente diferente:

- Hero interno de 320 px com margem 16, raio 24, gradiente, nome/endereço sobre a imagem, voltar e compartilhar sobrepostos.
- Sem foto, mostra placeholder; React omite a capa.
- Ações de telefone, Instagram, site e cardápio usam chips.
- Cardápio abre bottom sheet, agrupa categorias e mostra fotos.
- Próximos eventos usam mini cards em lista.
- Mostra responsável parceiro e botão de edição somente quando `currentUser.id == owner.id`.
- Compartilhamento oferece WhatsApp, copiar e share nativo em bottom sheet.

Mapeamento para reproduzir o React:

| React | Flutter para paridade |
| --- | --- |
| Shell global | Cabeçalho/container/rodapé responsivos da Home. |
| Foto acima da grade | `ClipRRect(14)` + 360/240; omitir quando vazia. |
| Artigo + aside | `Row` + aside 320; `Column` em ≤760. |
| Chips de gênero | `Wrap` com padding 7 × 11 e raio 20. |
| Galeria | Lista horizontal 180 × 130; excluir índice 0. |
| Cardápio inline | Expansion sem aparência Material adicional; lista plana. |
| Horários inline | Expansion separada; labels e formato exatos. |
| Eventos | Grid responsivo com o card da Home. |
| Aside | Container plano, padding 24, borda e gap 15. |
| Compartilhar | Web Share/clipboard no web; feedback dentro do aside. |

Se a experiência Flutter existente for mantida, registrar cada item acima como divergência deliberada. Não misturar parcialmente as duas hierarquias sem comparar navegação, foco, rolagem e ordem da informação.

## 14. Checklist de paridade

- [ ] Abrir por ID/slug, atualizar diretamente e voltar para a Home.
- [ ] Comparar 390, 760, 761, 1250 e 1440 px; escala 100%, 160% e 200%.
- [ ] Conferir foto presente/ausente, 360/240, recorte e ausência de overlay.
- [ ] Conferir zero, um e muitos gêneros e nome/endereço longos.
- [ ] Conferir descrição multilinha e galeria com zero, uma e muitas fotos.
- [ ] Testar HTTP, Data URI, Base64 puro e imagem inválida.
- [ ] Testar cardápio vazio, itens longos, preços zero/fracionários e categorias vazias.
- [ ] Testar horários vazios, todos os dias, valores limites e teclado.
- [ ] Testar próximos eventos vazios, atualização ao vivo, evento encerrando e erro da assinatura.
- [ ] Conferir grid de evento exatamente em 760/761.
- [ ] Testar telefone vazio/preenchido, site válido/inválido e coordenadas do Maps.
- [ ] Testar Web Share, cancelamento, clipboard e falhas.
- [ ] Conferir edição para owner ID, partnerId, usuário comum, admin e conta inativa.
- [ ] Conferir loading, sem Firebase, não encontrado, erro inicial e erro coexistente.
- [ ] Validar foco, ordem de tabulação, alt das imagens, áreas de toque e contraste.
- [ ] Corrigir e validar os caracteres corrompidos de metadata antes de publicar.

**Critério de conclusão:** Flutter deve manter hierarquia, dimensões, textos, estados, dados e breakpoints registrados, ou documentar as diferenças aprovadas. A comparação deve usar os mesmos dados, largura lógica, fonte, escala, locale e fuso.
