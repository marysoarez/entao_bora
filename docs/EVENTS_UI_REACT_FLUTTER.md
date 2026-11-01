# Eventos — referência visual e comportamental React → Flutter

Referência: código local em 16/09/2026, incluindo alterações presentes no diretório de trabalho. Escopo principal: detalhe público em `/events/{id ou slug}`, dentro do `Shell` da aplicação. O formulário de criação e edição já está documentado em [CRIACAO_EVENTO_REACT.md](CRIACAO_EVENTO_REACT.md); cards da Home estão documentados em [HOME_REACT_FLUTTER.md](HOME_REACT_FLUTTER.md).

Esta especificação foi conferida no código React e comparada com a implementação Flutter atual. Não houve validação ponta a ponta com Firebase, geolocalização ou navegador real. Medidas visuais são declarações CSS, salvo indicação contrária.

## 1. Onde a interface é construída

| Fonte | Responsabilidade |
| --- | --- |
| `react-web/src/features/events/pages/EventDetailsPage.tsx` | Entrada da rota; delega a tela ao detalhe compartilhado. |
| `react-web/src/features/entity-detail/EntityDetails.tsx` | Consulta, estados, metadados, conteúdo, ações, cardápio, horários e compartilhamento. |
| `react-web/src/app/App.tsx` | `Shell`: cabeçalho, container de até 1200 px, mensagens de sessão e rodapé. |
| `react-web/app/globals.css` | Dimensões, cores, tipografia e breakpoint de 760 px. |
| `react-web/src/core/repository.ts` | Resolução por ID/slug, interações, contadores e eventos relacionados. |
| `react-web/src/shared/domain.ts` | Datas, imagens, URLs, localização, distância e autorização de edição. |
| `react-web/src/shared/models.ts` | Contratos de Event, Place, Address e gêneros. |
| `react-web/components/ui/button.tsx` | Botões preenchido e outline. |
| `react-web/src/shared/ui/Message.tsx` | Mensagens de carregamento, ausência, erro e confirmação de cópia. |

Equivalentes Flutter atuais:

| Fonte | Responsabilidade atual |
| --- | --- |
| `lib/feature/events/presentation/pages/event_details_page.dart` | Carregamento e entrega para `EventCard`. |
| `lib/feature/events/presentation/widgets/event_card_widget.dart` | Composição do detalhe Flutter. |
| `event_header_widget.dart`, `event_info_widget.dart`, `event_genres_widget.dart` | Hero, informações e gêneros. |
| `event_actions_widget.dart`, `bora_button.dart`, `checkin_button.dart` | Bora, check-in e mensagens. |
| `event_details_skeleton.dart` | Skeleton Flutter, diferente do loading React. |
| `event_details_viewmodel.dart`, `events_bora_viewmodel.dart` | Consulta, visualização, local associado e interações. |

## 2. Rota, shell e composição

- Rota pública React: `/events/:id`; o parâmetro aceita ID de documento ou slug.
- A tela é renderizada dentro do mesmo cabeçalho, container e rodapé da Home. O cabeçalho e o rodapé não são fixos.
- O container externo tem largura máxima de 1200 px e padding vertical 48/60 px no desktop, 36/50 px entre 761 e 1250, e 30 px em todos os lados até 760, com laterais de 18 px.
- A página inteira rola. O aside não é sticky.

Ordem vertical:

```text
Cabeçalho global
Container
  ← Voltar para explorar
  Capa, quando existe
  Grade de detalhes
    Artigo principal
      Gêneros
      Título
      Início e término
      Endereço
      Link do estabelecimento, quando resolvido
      Sobre o evento
      Atrações, quando existem
      Galeria, quando existe
      Cardápio e horários do estabelecimento, quando resolvido
    Aside
      Ingresso
      Bora
      Check-in
      Como chegar
      Compartilhar
      Editar, quando autorizado
      Mensagem de erro ou confirmação
Rodapé global
```

O link de retorno usa apenas texto `← Voltar para explorar`, classe `subtle` e rota `/`. Não existe breadcrumb adicional.

## 3. Identidade visual

### Cores e superfícies

| Uso | Valor |
| --- | --- |
| Fundo da página | `#000000` |
| Texto principal | `#F6F4F2` |
| Texto de parágrafo | `#AAAAAA` |
| Texto sutil | `#777777` |
| Vermelho principal | `#D64545` |
| Link dentro de mensagem | `#EF8888` |
| Aside, details e mensagens | `#161616` |
| Chips | `#222222` |
| Borda do aside e itens de cardápio | `#333333` |
| Borda das mensagens | `#353535` |

As superfícies React são planas. O aside tem borda de 1 px e não recebe sombra. A capa e a galeria usam recorte; não há overlay ou gradiente sobre a capa no React.

### Tipografia

- Família: Arial, fallback Helvetica e sans-serif.
- Título do detalhe: 40 px no desktop e 32 px até 760; peso 700; tracking `-0.045em`.
- Títulos `h2`: 26 px, peso 700, tracking `-0.045em`.
- Títulos `h3`: 19 px; margem vertical 8 px.
- Parágrafos: cor `#AAA`, altura de linha 1,65 e margem vertical 8 px.
- Chips: 11 px.
- Eyebrow do aside: 10 px, peso 700, tracking 2 px, maiúsculas e cor `#AAA`.
- Link de retorno e textos com classe `subtle`: 11 px e `#777`.

No Flutter, o fallback Arimo incluído no projeto preserva as métricas de Arial quando Arial/Helvetica não estão disponíveis. Conferir quebra de título e escala de texto do sistema.

## 4. Layout e responsividade

| Propriedade | Acima de 760 px | Até 760 px |
| --- | --- | --- |
| Capa | 100% × 360 px; raio 14 | 100% × 240 px; raio 14 |
| Grade principal | `1fr 320px`; gap 40 | Uma coluna; gap 20 |
| Margem acima da grade | 28 px | 28 px |
| Título | 40 px | 32 px |
| Aside | 320 px na grade | Largura total abaixo do artigo |
| Galeria | Linha horizontal rolável | Mantém linha horizontal rolável |

- A capa usa `object-fit: cover`. Ela só é criada quando `coverImage` é não vazio; sem capa, não existe reserva de altura nem placeholder no React.
- A grade troca diretamente de duas colunas para uma em 760 px. Não há breakpoint intermediário próprio do detalhe.
- O aside tem padding 24, raio 12, borda `#333`, gap interno 15 e `align-self: start`.
- Em telas estreitas, o aside aparece depois de todo o artigo, inclusive cardápio, horários e galeria.
- Textos não possuem truncamento nem limite de linhas declarado.

## 5. Cabeçalho visual do evento

### Capa

- Origem: `coverImage`.
- `imageSource()` aceita HTTP(S), Data URI já pronta ou Base64 puro, convertido para Data URI JPEG.
- `alt`: título do evento.
- Não existe `loading="lazy"` na capa.
- O React não declara fallback para erro de download ou Base64 inválido.

### Gêneros e título

- Todos os gêneros são exibidos, sem limite.
- Container `.chips`: flex com quebra, gap 8 e margem vertical 16.
- Cada chip: fundo `#222`, padding vertical 7/horizontal 11, raio 20 e fonte 11.
- Os valores persistidos são convertidos pelas labels de `genres`; valores desconhecidos já são normalizados para `other` ao ler.
- O título é exibido integralmente em `h1`.

### Data, endereço e local

- Linha de datas: ícone Lucide `CalendarDays` 16 + `formatDate(startDate)` + ` — ` + `formatDate(endDate)`.
- `formatDate` usa `toLocaleString("pt-BR", {dateStyle: "medium", timeStyle: "short"})`, no fuso do navegador.
- Linha de endereço: `MapPin` 16 + `event.address.displayName`.
- As duas linhas são parágrafos; o CSS não define um layout especial para alinhar ícone e texto, portanto seguem o fluxo inline do navegador.
- Quando `placeId` existe e o estabelecimento é resolvido, aparece um link separado com `{place.name} ↗` para `/place/{slug ou id}`.
- Se o evento tem `placeId`, mas o local não é encontrado, o evento ainda aparece; o link, cardápio e horários não aparecem.
- Se a resolução do local lança erro, o evento já carregado permanece e a mensagem é mostrada no aside.

## 6. Conteúdo principal

### Sobre

- Título: `Sobre o evento`, com margem superior inline de 32 px.
- Descrição em parágrafo com `white-space: pre-wrap`; quebras e espaços relevantes são preservados.
- Texto vazio ainda produz o título e um parágrafo vazio.

### Atrações

- A seção só existe quando `attractions.length > 0`.
- Título: `Atrações`.
- Cada atração é um parágrafo com nome.
- Headliner acrescenta ` · Atração principal`.
- Foto e Instagram da atração não são exibidos nesta tela.
- Não há card, avatar, ordenação adicional nem link.

### Galeria

- Usa `event.gallery` inteira e preserva a ordem armazenada.
- Linha flex horizontal, gap 15, `overflow: auto` e margem vertical 25.
- Cada imagem mede 180 × 130, `object-fit: cover`, raio 8 e `loading="lazy"`.
- Alt: `Foto {índice a partir de 1} de {título}`.
- Sem itens, o container continua no DOM, porém sem altura útil; não há título ou mensagem de galeria vazia.

### Cardápio e horários do estabelecimento

Estas seções aparecem no evento somente se o `placeId` for resolvido para um Place.

**Cardápio**

- Elemento `<details>` inicialmente fechado.
- Summary: `Cardápio · {nome do local}`.
- Container: padding 18, fundo `#161616`, raio 10 e margem vertical 18; não há borda declarada.
- Com itens: cada `.menu-item` tem padding vertical 16, borda inferior `#333`, flex entre texto e preço, gap 20.
- Conteúdo: categoria em `<small>`, título em `h3`, descrição em parágrafo e preço forte à direita.
- Preço usa `Intl` pt-BR, moeda BRL.
- Sem itens: `Cardápio ainda não disponível.`
- A ordem persistida é preservada; não há agrupamento por categoria nesta versão React.

**Horários**

- Só aparece quando `openingHours.length > 0`.
- Outro `<details>` inicialmente fechado, summary `Horários de funcionamento`.
- Uma linha por item, na ordem persistida.
- Dias reconhecidos: monday a sunday → Segunda a Domingo.
- Hora e minuto recebem zero à esquerda; formato `{dia}: HH:MM às HH:MM`.
- Não há tratamento visual de “fechado”, intervalo atravessando meia-noite ou dia desconhecido.

## 7. Aside: ingresso e ações

### Ingresso

- Eyebrow: `ENCONTRE A GALERA`.
- Gratuito: título `Entrada gratuita`.
- Externo: título `Garanta seu ingresso`.
- O link `Comprar ingresso ↗` só aparece quando `safeUrl(ticketUrl)` aceita HTTP ou HTTPS.
- Um ticket externo com URL ausente ou inválida mantém o título, sem link e sem mensagem específica.

### Então Bora

- Botão preenchido com ícone Lucide `Heart` 17.
- Estado inicial sem sessão: falso.
- Rótulo inativo: `Então Bora!`; ativo: `Você vai! Desmarcar`.
- Sem sessão, o clique abre login e encerra a ação; não marca automaticamente após login.
- Com sessão, usa transação para criar/remover `events/{id}/boras/{user.id}` e ajustar `boraCount`.
- A tela acompanha em tempo real o documento da interação do usuário.
- O contador não é mostrado no botão React de detalhes.
- `busy` desabilita Bora, check-in e compartilhar durante qualquer ação controlada por `action()`.

### Check-in

- Botão outline com ícone `Check` 17.
- Rótulo inicial: `Fazer check-in`; concluído: `Check-in realizado`.
- Depois de concluído, fica desabilitado.
- Texto auxiliar: `Durante o evento, a até 100 metros do endereço.`
- Sem sessão, abre login e encerra a ação.
- Solicita geolocalização com alta precisão, timeout 15 s e cache zero.
- A regra persistida permite evento publicado, instante entre início e término **inclusive** e distância menor ou igual a 100 m.
- Documento de check-in já existente torna a transação idempotente, sem novo incremento.
- Erros de permissão, distância, período ou backend aparecem na mensagem do aside.

### Como chegar

- Link sempre presente.
- URL: `https://www.google.com/maps/search/?api=1&query={latitude},{longitude}`.
- Abre nova aba com `target="_blank"` e `rel="noreferrer"`.
- Não usa o endereço textual na consulta.

### Compartilhar

- Botão outline com `Share2` 16 e texto `Compartilhar`.
- URL canônica da ação: `VITE_PUBLIC_BASE_URL` ou `window.location.origin`, sem barra final, seguido por `/events/{slug ou id}`.
- Com Web Share API: compartilha `{title, url}`.
- Sem Web Share API: copia URL para clipboard e mostra `Link copiado!` na caixa de mensagem do aside.
- Após compartilhar ou copiar, tenta incrementar `shares`.
- Cancelamento com erro `AbortError` é ignorado. Outros erros substituem a mensagem atual.

### Editar

- Link: `Editar informações` → `/events/{entity.id}/edit`; usa sempre ID, não slug.
- Visível quando usuário está ativo e o `createdBy` equivale a `user.id`, ou quando usuário é parceiro ativo e `createdBy == user.partnerId` não vazio.
- Admin não recebe permissão implícita por papel nessa função.

## 8. Carregamento, ausência e erros

| Estado | React atual |
| --- | --- |
| Carregando entidade | Caixa `Carregando detalhes…`; não usa skeleton. |
| Firebase sem configuração | Caixa `Os detalhes estarão disponíveis após conectar a agenda.` + link para explorar. |
| ID e slug ausentes | `Não encontramos este registro.` + link. |
| Falha inicial | Texto do erro + `Explorar outros rolês`. |
| Falha ao resolver local | Evento continua; erro aparece no aside. |
| Falha na assinatura Bora/check-in | Estado anterior permanece; mensagem no aside. |
| Login cancelado | O tratamento depende do provider de sessão; a ação não é repetida. |
| Compartilhamento copiado | `Link copiado!` usa visual de mensagem, embora seja sucesso. |
| Erro de imagem | Sem fallback explícito. |

Caixa Message: padding 24, margem vertical 20, fundo `#161616`, borda `#353535`, raio 10 e texto `#CCC`. Links usam `#EF8888` e sublinhado.

O React resolve primeiro por ID; se o documento não existir, consulta `slug == parâmetro`, limite 1. Não restringe status no detalhe público: um ID/slug de draft, cancelled, finished ou hidden pode ser resolvido pelo cliente, sujeito às regras do banco.

## 9. Metadados, contadores e ciclo de vida

- Após carregar, define título da página como ``{evento.title} ? Ent?o Bora`` no código local atual. Os caracteres `?` estão literalmente presentes e representam uma falha de codificação a corrigir, não o texto final recomendado.
- Descrição de metadata: `event.description`.
- Imagem: capa passada por `safeUrl`. Base64 puro não vira Data URI aqui e, portanto, não produz imagem de metadata.
- Ao desmontar, restaura metadata padrão, também com caracteres corrompidos no código local.
- A primeira carga de cada ID por montagem incrementa `views`; falha de contagem é ignorada.
- O `Set` local evita nova contagem do mesmo evento enquanto a mesma instância de tela permanece montada.
- Trocar sessão reinicia os estados locais Bora/check-in para falso e cria ou remove as assinaturas apropriadas.
- Todos os efeitos usam limpeza ou flag `alive` para evitar atualização após desmontagem.

## 10. Paridade Flutter

O Flutter atual apresenta uma experiência própria: hero de 420/300 no skeleton, ações largas com gradiente, contadores nos botões, Material Icons, mensagens por SnackBar e composição em `EventCard`. Isso não é paridade direta com o detalhe React descrito acima.

Mapeamento sugerido:

| React | Flutter para paridade |
| --- | --- |
| Shell + container | Reutilizar shell responsivo da Home e `ConstrainedBox(maxWidth: 1200)`. |
| `.detail-cover` | `ClipRRect(radius: 14)` + `SizedBox(height: 360/240)` + `Image(..., fit: cover)`. |
| `.detail-columns` | `Row` com artigo expandido e aside 320; `Column` até 760. |
| Chips | `Wrap(spacing: 8, runSpacing: 8)` e containers 7 × 11. |
| Descrição pre-wrap | `Text` preservando `\n`; não limitar linhas. |
| Galeria | `ListView.horizontal`, itens 180 × 130, gap 15. |
| `<details>` | `ExpansionTile` controlado ou componente sem padding Material automático. |
| Aside | Container plano, padding 24, borda 1, raio 12 e gap 15. |
| Bora/interações | Assinatura pelo ID real resolvido e estado reativo da sessão. |
| Compartilhar | Share nativo; no web, clipboard como fallback e incremento de shares. |

Pontos de integração que precisam ser preservados:

- Depois de resolver slug, usar `event.id` para views, shares, Bora e check-in.
- O local associado é complementar; sua falha não deve apagar o evento carregado.
- Check-in precisa validar tempo e distância também no backend/regras; validação visual isolada não protege o dado.
- O Flutter atual usa comparações estritas `isAfter/isBefore` no ViewModel, enquanto o React aceita exatamente início e término. Decidir e testar os instantes limite antes de declarar paridade.
- O Flutter atual exibe contadores e rótulos diferentes (`ENTAO BORA`, `BORA!`, `CHEGUEI`); reproduzir os textos React exige mudança deliberada.

## 11. Checklist de paridade

- [ ] Abrir por ID e slug, atualizar a página diretamente e voltar para `/`.
- [ ] Comparar 390, 760, 761, 1250 e 1440 px, com escala de texto 100%, 160% e 200%.
- [ ] Conferir capa presente/ausente, proporções 360/240, raio 14 e `cover`.
- [ ] Conferir título longo, descrição com múltiplas linhas e todos os chips.
- [ ] Validar data no mesmo fuso e locale pt-BR.
- [ ] Testar evento avulso, local válido, placeId inexistente e erro ao carregar o local.
- [ ] Testar atrações vazias, headliner, galeria vazia, Base64, Data URI, HTTP e imagem inválida.
- [ ] Testar cardápio vazio/com itens, horários vazios/com todos os dias e expansão por teclado.
- [ ] Testar ingresso gratuito, externo válido e externo inválido.
- [ ] Testar Bora sem sessão, marcado/desmarcado, conta inativa, erro e atualização em outra aba.
- [ ] Testar check-in sem sessão, permissão negada, antes/início/durante/término/depois e 99/100/101 m.
- [ ] Testar Web Share, cancelamento, clipboard, falha do clipboard e incremento de shares.
- [ ] Conferir link de edição para proprietário, partnerId, usuário comum, admin e conta inativa.
- [ ] Conferir loading, não encontrado, sem Firebase, erro inicial e erro coexistindo com conteúdo.
- [ ] Validar foco visível, ordem de tabulação, labels, textos alternativos e movimento reduzido quando aplicável.
- [ ] Corrigir e validar os caracteres corrompidos dos metadados antes de publicação.

**Critério de conclusão:** a versão Flutter deve reproduzir hierarquia, medidas, textos, estados e regras registradas acima nos breakpoints equivalentes, ou listar cada diferença deliberada. A comparação visual deve usar os mesmos dados, largura lógica, fonte disponível, escala, locale e fuso.
