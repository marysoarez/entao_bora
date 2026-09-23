# Área do parceiro — contrato atual Flutter → React

Referência: implementação local conferida em 16/09/2026. Este documento é o material de entrega para reproduzir no React o comportamento atual do Flutter. Descreve código inspecionado, não uma validação com dados reais do Firebase. As diferenças abaixo ainda precisam ser implementadas/validadas para declarar os projetos pareados.

## 1. Fontes e acesso

- Flutter: `lib/feature/partner_dashboard/presentation/pages/partner_dashboard_page.dart`, `viewmodels/partner_dashboard_viewmodel.dart` e `widgets/` na mesma feature.
- Gestão de locais: `lib/feature/places/presentation/manage_places_page.dart`, `create_place_page.dart` e `create_place_viewmodel.dart`.
- Cardápio: `lib/feature/menu_management/presentation/`.
- React: `react-web/src/features/partner-dashboard/PartnerDashboardPage.tsx`, `src/features/management/ManagementModule.tsx`, `src/core/repository.ts` e `app/globals.css`.
- Rota principal nos dois projetos: `/partner-dashboard`.

Flutter recebe um `PlaceEntity` opcional por argumento. Ao entrar, define a seleção inicial e chama `loadDashboard()`. A sessão é consultada com `forceRefresh: true`. Sem usuário, apresenta erro de login; sem `isPartner`, apresenta erro de acesso. `isPartner` significa exclusivamente `role == partner`: admin não é automaticamente parceiro. Esse viewmodel não verifica `active`; o Guard React verifica conta ativa. Registrar essa diferença de acesso e manter a proteção React, sem removê-la para imitar a ausência de validação Flutter. Regras implantadas do Firestore não foram verificadas.

## 2. Dados, seleção e regra central de eventos

1. Construir a lista de identificadores: `user.id` e `partnerId` não vazio, sem duplicatas.
2. Buscar estabelecimentos por proprietário para cada identificador.
3. Buscar eventos por criador para cada identificador e deduplicar por ID.
4. Resolver a seleção pelo ID do objeto inicial/anterior dentro dos locais recém-carregados; se não existir, escolher o primeiro; sem locais, usar `null`.
5. Recalcular lista e métricas com a regra abaixo.

A consulta Flutter de eventos aceita `createdBy` string e `createdBy.id`, resolve o usuário criador e ordena cada resultado por `startDate` crescente. Se o usuário criador não for encontrado, essa consulta retorna lista vazia. A união de consultas para `user.id` e `partnerId` não recebe uma nova ordenação global. O painel não consulta todos os eventos de um estabelecimento: seu universo são os eventos dos criadores acessíveis ao parceiro.

```ts
// Aplicar somente sobre os eventos já carregados para user.id/partnerId.
function visibleEvents(events: Event[], selectedPlace: Place | null): Event[] {
  if (!selectedPlace) return events;
  return events.filter((event) => {
    const id = event.placeId?.trim();
    return !id || id === selectedPlace.id;
  });
}
```

| Situação do evento carregado | Selecionado local A | Selecionado local B | Sem local cadastrado |
| --- | --- | --- | --- |
| Vinculado a A | Incluído | Excluído | Incluído |
| Vinculado a B | Excluído | Incluído | Incluído |
| `placeId` nulo, vazio ou apenas espaços | Incluído | Incluído | Incluído |

Eventos avulsos aparecem em qualquer local selecionado: não há associação por endereço ou proximidade. Não somar resumos de vários locais para obter um total único, pois os avulsos se repetem entre seleções. Sem estabelecimento, todos os eventos carregados continuam acessíveis, inclusive referências a locais não presentes na lista.

Não existe filtro por data ou status no painel. Apesar do título Flutter `Proximos eventos`, podem aparecer eventos encerrados, rascunhos e cancelados retornados pelo repositório. Essa regra é diferente da seção pública de próximos eventos.

## 3. Composição e estados

Ordem no Flutter:

1. AppBar `Gestão do estabelecimento`, voltar e `Atualizar`.
2. Saudação `Olá, {nome}`, texto `Cuide dos seus estabelecimentos, cardápios e eventos em um só lugar.`, ações `Criar evento` e `Novo local`.
3. Quando há locais: seletor com nome, endereço e edição; quatro atalhos de gestão.
4. `Resumo`: Eventos, Visualizações, Boras e Check-ins.
5. `Proximos eventos`: lista com ações de visualizar, editar e transferir.

| Condição, em ordem de prioridade | Comportamento Flutter |
| --- | --- |
| `loading` | Skeleton substitui o conteúdo; atualização desabilitada. |
| Erro e lista de locais vazia | Estado `Nao foi possivel abrir o dashboard`, mensagem e `Tentar novamente`. |
| Sem locais e sem eventos, sem erro | Estado `Nenhum estabelecimento cadastrado` com `Cadastrar estabelecimento`. |
| Sem locais, mas com eventos, sem erro | Cabeçalho, criação de evento/local, métricas e eventos; omitir seletor e atalhos dependentes de local. |
| Locais disponíveis e erro | Manter conteúdo e mostrar erro inline. |
| Local selecionado sem eventos visíveis | Métricas zero e estado `Nenhum evento futuro`, com `Criar evento`. |

Falha ao buscar locais interrompe a carga. Falha ao buscar eventos de um criador registra erro, produz uma lista vazia para essa consulta e permite continuar as demais. Trocar o local recalcula `visibleEvents` e limpa o erro. As consultas são pontuais; não há assinatura em tempo real ou atualização periódica do painel.

## 4. Atalhos e navegação para o React

| Ação | Flutter atual | Equivalente React |
| --- | --- | --- |
| Novo local | `/places/create`, sem argumento | `/places/create` |
| Informações / Editar local | `/places/create`, argumento Place | `/places/{id}/edit` |
| Cardápio / Gerenciar | `/places/menu`, argumento Place | `/places/menu?placeId={id}` |
| Programação / Criar evento | `/events/create`, argumento Place selecionado ou null | `/events/create?placeId={id}`, ou sem query quando não há local |
| Página pública | URL de local por slug, fallback ID | `/place/{slug ou id}` |
| Editar evento | `/events/create`, argumento Event | `/events/{id}/edit` |
| Ver evento | URL de evento por slug, fallback ID | `/events/{slug ou id}` |

Atalhos: Informações (`Dados, contatos, horários e fotos`); Cardápio (`{N} item(ns) publicado(s)`); Programação (`Crie um evento vinculado a este local`); Página pública (`Confira como o público vê o local`). A contagem é `menuItems.length`, sem filtro de publicação.

Flutter recarrega o dashboard quando as rotas de criação/edição/cardápio retornam `true`. O editor de local retorna `true` ao salvar. O editor de cardápio salva durante a permanência na tela e não retorna explicitamente `true` no voltar comum: o resumo pode ficar desatualizado até atualizar manualmente. Para React, garantir recarga ao retornar de alterações e manter o local selecionado na URL. Não transportar objetos antigos como única fonte para uma gravação.

## 5. Métricas e conteúdo de cada evento

As quatro métricas derivam exatamente de `visibleEvents`: quantidade, soma de `views`, soma de `boraCount` e soma de `checkinCount`. Não representam todos os eventos públicos do local nem usuários únicos. `shares` aparece em cada evento, mas não possui card agregado.

Cada evento Flutter apresenta:

- Capa 112 × 112, raio 8; placeholder quando vazia; implementação atual usa decodificação Base64.
- Título 18 px em negrito; descrição limitada a três linhas.
- Status, nome do criador, Instagram quando não nulo.
- Nome do local, endereço completo, início e término (`DD/MM/AAAA - HH:MM`), ingresso gratuito ou URL externa e quantidade de fotos da galeria.
- Todos os gêneros musicais e nomes das atrações, quando presentes.
- Views, Boras, check-ins e compartilhamentos.
- Ações com identificação acessível: `Ver evento`, `Editar evento`, `Transferir evento`.

O React atual mostra apenas parte desses dados. Para equivalência de conteúdo, incluir os campos faltantes; o modelo React guarda o criador como ID, portanto o nome precisa ser resolvido usando o contrato de usuários disponível, sem exibir o ID como se fosse nome.

## 6. Transferência

Flutter abre diálogo `Transferir evento`, campo `ID do usuario de destino`, ações Cancelar e Transferir. O texto é normalizado com `trim`; vazio ou cancelamento não executa operação. Busca o usuário pelo ID e, se existir, atualiza o evento com esse criador e `updatedAt = agora`, preservando o `placeId`. Depois recarrega o dashboard e mostra `Evento transferido para {nome}.`; em falha, mostra a mensagem do erro.

No React, usar a operação de transferência existente, que verifica permissões em transação; não substituir por uma escrita sem autorização. Reconsultar os eventos após sucesso para representar corretamente inclusive transferência para a própria conta ou para outro identificador ainda acessível. A remoção local incondicional do evento não reproduz esse caso. O Flutter atual não possui trava específica de operação em andamento nesse diálogo; isso é uma limitação, não um requisito a copiar.

## 7. Edição de local e cardápio

O editor de estabelecimento reúne nome, descrição, endereço/número/complemento, tipo, gêneros, telefone, Instagram, site, horários e fotos. As validações atuais incluem nome, descrição, endereço, ao menos um gênero, slug e parceiro autenticado. Consultar `create_place_viewmodel.dart` antes de alterar contratos de persistência.

O cardápio trabalha com `menuItems` e `menuCategories` do Place:

- Criar, editar e remover item; exclusão pede confirmação na página Flutter.
- Item: ID, título, descrição, preço numérico, foto e categoria; edição preserva a posição do item na lista Flutter.
- Criar categoria com nome aparado; rejeitar duplicata ignorando maiúsculas/minúsculas.
- Categorias vêm tanto de `menuCategories` quanto dos itens. `Geral` aparece primeiro; as demais são ordenadas por nome. Categoria vazia de item aparece em `Geral`.
- O viewmodel salva via `updatePlace`, atualiza sua seleção local e exibe retorno de sucesso/erro. Não há renomeação ou exclusão de categoria nesse fluxo.

No React, preservar a transação de cardápio existente e manter os demais campos do documento. Após salvar, recarregar contagens do painel. Verificar criação, edição, remoção e confirmação, inclusive categoria vazia e duplicada.

## 8. Aparência e limites de responsividade

Flutter usa fundo preto, superfície `#161616`, destaque `#D64545`, texto branco e texto secundário branco70. `DsAdminPage` tem largura máxima 1200 e padding 24. Cabeçalho usa Wrap com espaçamento 16. Não confundir largura disponível do componente com largura total da janela.

| Elemento Flutter | Medidas atuais |
| --- | --- |
| Atalhos | 4 colunas em largura disponível ≥900; 2 em ≥560; 1 abaixo de 560; gap 16. |
| Card de atalho | Altura fixa 200, padding 20, raio 12, borda `#333`, ícone 28. |
| Métricas | 4 colunas em ≥900; 2 em ≥600; 1 abaixo de 600; gap 16; valor 28 px. |
| Seções | Espaçamento principal 36; título de seção herdado do tema. |
| Lista de eventos | Card com separadores; linha inicial fixa com capa, resumo e ações. |

O React tem identidade semelhante, mas usa Arial, texto `#F6F4F2`/`#AAA`, cards com raio 10 e grades com breakpoints de viewport 1250/760. Não há comprovação de paridade visual pixel a pixel. A linha inicial do evento Flutter e os atalhos com altura fixa precisam de validação em tela estreita e texto ampliado; não tratar o skeleton responsivo como prova de que a lista real também é responsiva.

## 9. Pendências concretas para parear o React

| React inspecionado | Mudança necessária para o comportamento Flutter atual |
| --- | --- |
| Filtro estrito `event.placeId === placeId` | Aplicar a regra da seção 2, incluindo nulo/vazio/espaços. |
| Retorno de estado vazio sempre que não há locais | Mostrar resumo e eventos quando há eventos carregados; vazio apenas quando ambos os conjuntos estiverem vazios. |
| Erro inicial junto da mensagem de ausência de locais | Distinguir falha de consulta de ausência de registros; oferecer nova tentativa. |
| Transferência remove o evento localmente | Recarregar a lista e métricas após sucesso. |
| Linha de evento resumida | Adicionar descrição, status, criador resolvido, término, endereço, ingresso, gêneros, atrações, galeria e shares. |
| Query string de seleção | Manter, pois permite abertura direta; resolver ID inacessível para seleção disponível sem conceder acesso ao objeto solicitado. |

O Guard React exige conta ativa, ao contrário do viewmodel Flutter: manter essa proteção e registrar como diferença até uniformizar a política. As escolhas de diálogo versus formulário inline e os breakpoints precisam ser alinhadas se a entrega exigir equivalência visual além da funcional.

## 10. Aceite com os mesmos dados nos dois projetos

- [ ] Parceiro com `user.id` e `partnerId`: carregar ambos e deduplicar documentos.
- [ ] Locais A e B; eventos vinculados a cada um; avulsos com null, vazio e espaços: conferir a tabela da seção 2 e todos os totais.
- [ ] Sem locais com eventos: permitir visualizar/editar/transferir e criar evento sem local pré-selecionado.
- [ ] Sem locais e sem eventos: apresentar cadastro; falha de rede: apresentar erro e tentativa.
- [ ] Conferir rascunho, cancelado e encerrado: não aplicar filtro público silenciosamente.
- [ ] Trocar local, atualizar e voltar dos editores: manter seleção válida e renovar dados.
- [ ] Conferir todos os campos de evento, inclusive compartilhamentos e nome do criador.
- [ ] Transferir para terceiro, para a própria conta e para identificador acessível; conferir a lista após recarga; destino inválido não altera dados.
- [ ] CRUD do cardápio, confirmação de exclusão, categorias e preço; preservar informações do local.
- [ ] Testar 390, 560, 600, 760, 900, 1250 e 1440 px, texto 100%/160%/200%, teclado e nomes longos.

Documentação atualizada por inspeção de código. Os itens acima são critérios a executar, não resultados de testes já realizados. Nenhuma alteração de implementação React é feita por este documento.
