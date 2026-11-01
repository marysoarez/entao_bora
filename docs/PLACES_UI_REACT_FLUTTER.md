# Estabelecimentos — referência visual e comportamental React → Flutter

Referência: código local em 16/09/2026, incluindo alterações presentes no diretório de trabalho. O documento cobre o detalhe público em `/place/{id ou slug}` e o painel administrativo em `/partner-dashboard`, ambos dentro do `Shell`. O formulário completo de criação/edição e o editor de cardápio continuam complementados pelo escopo geral em [MIGRACAO_REACT.md](MIGRACAO_REACT.md); o card resumido da Home está em [HOME_REACT_FLUTTER.md](HOME_REACT_FLUTTER.md).

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
| `react-web/src/features/partner-dashboard/PartnerDashboardPage.tsx` | Painel dedicado, seleção de local, atalhos, métricas, eventos e transferência. |
| `react-web/src/features/management/ManagementModule.tsx` | Formulários de local, cardápio e gestão legada compartilhada. |

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
| `lib/feature/partner_dashboard/presentation/pages/partner_dashboard_page.dart` | Composição do painel de gestão do estabelecimento. |
| `partner_place_management_section.dart` | Atalhos de informações, cardápio, programação e página pública. |
| `partner_dashboard_viewmodel.dart` | Locais e eventos do parceiro, seleção, filtro e métricas. |

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
- Na implementação Flutter, a seção também inclui eventos avulsos criados pelo proprietário do estabelecimento: `createdBy` corresponde ao `ownerId` e `placeId` é nulo ou vazio. Assim, eventos cadastrados apenas com endereço aparecem junto dos vinculados diretamente ao estabelecimento.
- Os dois conjuntos são mesclados por ID, filtrados para status publicado e término atual ou futuro, e ordenados pelo término. Eventos do proprietário vinculados a outro estabelecimento não entram nesta seção.
- No painel Flutter atual, a programação e as métricas incluem eventos do local selecionado e eventos avulsos dos criadores acessíveis ao parceiro (`user.id`/`partnerId`). `placeId` nulo, vazio ou apenas espaços caracteriza evento avulso. Sem locais cadastrados, os eventos carregados continuam acessíveis. O React ainda precisa reproduzir essa regra; veja [Área do parceiro — contrato Flutter → React](AREA_PARCEIRO_FLUTTER_REACT.md).
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

## 13. Painel de gestão do estabelecimento

**Referência para a entrega ao React:** [AREA_PARCEIRO_FLUTTER_REACT.md](AREA_PARCEIRO_FLUTTER_REACT.md) descreve o Flutter atual e as pendências de paridade. Esta seção registra também o React inspecionado, que ainda apresenta diferenças: filtro estrito por local e bloqueio da lista quando não há estabelecimentos. Esses dois comportamentos devem ser corrigidos no React para preservar o acesso aos eventos avulsos.

### Rota, acesso e fontes

- Rota: `/partner-dashboard`, protegida por `Guard partner`.
- Exige sessão, conta ativa e `isPartner(user)`. O papel `admin` isolado não passa pela regra de parceiro.
- Entrada de navegação no cabeçalho: `Gestão do estabelecimento`.
- A página usa `owned("places", user)` e `owned("events", user)` em paralelo.
- `owned` consulta tanto campos string quanto `{campo}.id` para `user.id` e `partnerId`, quando presente, e deduplica documentos por ID.
- A implementação principal está em `react-web/src/features/partner-dashboard/PartnerDashboardPage.tsx`; o painel não depende mais da apresentação genérica de `Management`.

### Seleção e URL

- O estabelecimento selecionado é persistido em `?placeId={id}`.
- Sem `placeId`, o primeiro local carregado é selecionado e escrito na URL com `replace`.
- Um ID ausente ou inválido cai visualmente no primeiro estabelecimento disponível.
- Trocar o `<select>` atualiza a URL com `replace`, sem empilhar uma entrada de histórico para cada troca.
- O endereço (`address.displayName`) aparece abaixo do seletor.
- Todas as ações, métricas e listas seguintes usam o objeto selecionado.

### Cabeçalho e ações globais

Ordem:

```text
ÁREA DO PARCEIRO
Gestão do estabelecimento
Cuide dos seus locais, cardápios e eventos em um só lugar.
Criar evento | Novo local | Atualizar painel
```

- `Criar evento` abre `/events/create?placeId={id selecionado}`.
- `Novo local` abre `/places/create`.
- Atualizar executa novamente as duas consultas, limpa o erro anterior durante a tentativa e mantém a seleção quando o ID ainda existe.
- O botão de atualização possui `aria-label="Atualizar painel"`.

### Atalhos do estabelecimento

O título é `Gestão do estabelecimento`, seguido de texto contextual com o nome do local. A grade possui quatro cards inteiramente clicáveis:

| Card | Texto auxiliar | Destino |
| --- | --- | --- |
| Informações | Dados, contatos, horários e fotos | `/places/{id}/edit` |
| Cardápio | `{N} item(ns) publicado(s)` | `/places/menu?placeId={id}` |
| Programação | Crie um evento vinculado a este local | `/events/create?placeId={id}` |
| Página pública | Confira como o público vê o local | `/place/{slug ou id}` |

Cada card usa fundo `#161616`, borda `#333`, raio 10, padding 20 e altura mínima 200. O ícone é vermelho `#D64545`; o link de ação permanece no rodapé do card. No hover, a borda passa a `#666` e o card sobe 2 px.

### Métricas

- Grade com `Eventos`, `Visualizações`, `Boras` e `Check-ins`.
- No React inspecionado, `Eventos` é a quantidade de eventos filtrados estritamente pelo `placeId` selecionado. Para paridade com o Flutter, incluir também os eventos avulsos carregados para o parceiro.
- Os outros valores são somas de `views`, `boraCount` e `checkinCount` desse mesmo conjunto.
- Regra exigida para paridade: incluir eventos sem `placeId` (nulo/vazio/espaços) em toda seleção; excluir os vinculados a outro estabelecimento. Sem estabelecimento selecionado, usar todos os eventos carregados. Calcular as quatro métricas sobre essa mesma lista.
- Cards usam fundo `#161616`, borda `#333`, raio 10 e padding 20; valor em 30 px.

### Eventos e transferência

- Título: `Eventos do estabelecimento`, acompanhado por `{N} evento(s)`.
- A ordem é a devolvida por `owned`; o painel não aplica ordenação adicional nem filtra por status ou data.
- Cada linha mostra título com link público por slug/ID, data inicial, local, views, Boras e check-ins.
- `Editar` abre `/events/{id}/edit`.
- `Transferir` abre formulário inline, exige o ID do usuário de destino e chama `transferEvent`.
- Após transferência bem-sucedida, o evento é removido do estado local; o vínculo com o estabelecimento é mantido pelo repositório.
- Sem eventos vinculados: Message `Nenhum evento vinculado a este estabelecimento.` com link para criação já parametrizado.

### Estados e ciclo de vida do painel

| Estado | Apresentação |
| --- | --- |
| Carregamento | Message `Carregando a gestão do estabelecimento…` substitui o painel. |
| Erro de consulta/ação | Message no começo do conteúdo; atualizar limpa o erro antes de tentar novamente. |
| Sem estabelecimentos no React inspecionado | Estado centralizado com CTA; corrigir para manter resumo e eventos quando houver eventos carregados. |
| Sem eventos do local | Message dentro da seção de eventos, com link de criação. |
| Transferindo | Botão desabilitado e texto `Transferindo…`. |
| Troca de usuário/desmontagem | Flag local impede atualização de estado pela carga inicial já encerrada. |

O Flutter mantém os eventos acessíveis mesmo sem estabelecimentos. No React, o estado de cadastro deve aparecer somente quando não houver locais nem eventos (e nenhuma falha de carregamento). Com eventos e sem locais, mostrar cabeçalho, resumo, lista e ações de criar evento/local, omitindo apenas seletor e atalhos dependentes de estabelecimento.

### Responsividade do painel

| Largura | Atalhos | Métricas | Cabeçalho e eventos |
| --- | --- | --- | --- |
| Acima de 1250 px | 4 colunas | 4 colunas | Cabeçalho horizontal; evento em linha. |
| 761–1250 px | 2 colunas | 2 colunas | Cabeçalho horizontal enquanto houver espaço. |
| Até 760 px | 1 coluna | 1 coluna | Cabeçalho e linha de evento empilhados; CTAs ocupam o espaço disponível. |

No mobile, o `h1` do painel usa 32 px e os cards de atalho passam para altura mínima 184 px. A página continua dentro do container global com padding lateral de 18 px.

### Correspondência com o Flutter atual

O painel Flutter implementado em `feature/partner_dashboard` mantém a mesma jornada principal:

- seleção de estabelecimento;
- quatro atalhos equivalentes;
- quatro métricas calculadas sobre eventos vinculados ao local selecionado mais os eventos avulsos acessíveis ao parceiro;
- eventos do estabelecimento com edição e transferência;
- estado vazio orientado ao cadastro quando não existem locais nem eventos; eventos permanecem acessíveis sem local cadastrado;
- quatro, duas e uma coluna conforme espaço disponível.

Diferenças deliberadas de plataforma:

- React persiste a seleção em query string; Flutter mantém o objeto selecionado no viewmodel/argumento de navegação.
- React usa cards/link HTML e Message; Flutter usa `Material`/`InkWell`, `DsEmptyState` e `DsInlineError`.
- React apresenta a transferência em formulário inline; Flutter usa diálogo.
- Os breakpoints internos do Flutter são 900 e 560 px para os atalhos e 900/600 px para métricas, enquanto o React muda em 1250 e 760 px.

## 14. Paridade Flutter do detalhe público

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

## 15. Checklist de paridade

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
- [ ] Abrir `/partner-dashboard` diretamente com e sem `placeId`, inclusive ID inválido.
- [ ] Conferir seleção com um e vários estabelecimentos e persistência após atualizar.
- [ ] Validar os quatro atalhos com ID/slug e criação de evento pré-selecionada.
- [ ] Confirmar que métricas e lista incluem os eventos avulsos do parceiro (null, vazio e espaços), além dos vinculados ao local selecionado, excluindo os vinculados a outros locais.
- [ ] Confirmar que eventos e métricas continuam visíveis sem estabelecimento cadastrado.
- [ ] Testar painel sem local, local sem eventos, falha de consulta e atualização manual.
- [ ] Testar transferência bem-sucedida, usuário inexistente, falha de autorização e cancelamento.
- [ ] Comparar o painel em 390, 760, 761, 1250 e 1440 px e com texto ampliado.

**Critério de conclusão:** Flutter deve manter hierarquia, dimensões, textos, estados, dados e breakpoints registrados, ou documentar as diferenças aprovadas. A comparação deve usar os mesmos dados, largura lógica, fonte, escala, locale e fuso.
