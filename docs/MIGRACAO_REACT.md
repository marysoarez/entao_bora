# Então Bora — documentação para migração para React

## 1. Objetivo e escopo

Documentação elaborada em 09/09/2026 a partir do código do workspace, incluindo alterações locais ainda não commitadas. Permite implementar a versão React com rastreabilidade das funcionalidades e compatibilidade com os dados atuais.

**Premissa: React para web responsivo**, substituindo Flutter Web e preservando inicialmente Firebase, IDs, slugs e URLs públicas. Migrar Android/iOS/desktop também exige um escopo específico; esta proposta não contempla React Native.

“Atual” significa observado no código; “proposto” significa uma orientação ainda não implementada. Não houve execução do aplicativo, inspeção visual, consulta ao banco ou ao console Firebase. A presença de código não comprova funcionamento em produção.

## 2. Produto e arquitetura atual

O aplicativo permite descobrir estabelecimentos e eventos musicais no mapa, consultar detalhes e cardápios, marcar interesse (Bora), fazer check-in por proximidade e consultar atividades pessoais. Parceiros gerenciam locais, eventos e cardápios.

| Camada | Implementação atual | Responsabilidade |
| --- | --- | --- |
| Interface | Flutter / Material | Páginas, widgets, formulários e modais |
| Estado | MobX, viewmodels | Carregamento e ações observáveis |
| Rotas/dependências | Flutter Modular, `lib/app/app_module.dart` | Registro efetivo de telas e serviços |
| Domínio | `domain/entities/`, `domain/repositories/` | Entidades e contratos |
| Dados | DTOs, datasources e repositories | Serialização e acesso ao Firebase |
| Autenticação | Firebase Auth, SessionStore, AuthViewModel | Google e sessão |
| Persistência | Cloud Firestore | Usuários, locais, eventos e interações |
| Mapas | Google Maps, Places e Geocoding | Mapa, endereços e coordenadas |
| Notificações | FCM e service worker | Permissão e registro de tokens |

`lib/main.dart` inicializa locale `pt_BR`, Firebase, URLs sem hash e `AppModule`. Este módulo é a fonte efetiva das rotas; os módulos separados de home/eventos não são montados ali.

Diretórios de referência: `lib/feature/` (funcionalidades), `lib/core/` (infraestrutura), `lib/shared/` (design system e utilitários), `web/` (entrada, manifest, worker), `assets/images/`, `test/` e `tool/`.

O `pubspec.yaml` exige Dart `^3.9.2` e declara Storage, Analytics, Crashlytics, flutter_map e outras dependências. Dependência declarada não equivale a fluxo ativo: o mapa principal usa Google Maps e as imagens dos formulários são convertidas em Base64. Há splash sem rota ativa, DTO de presença comentado e código auxiliar/legado.

## 3. Rotas e navegação

Fonte: [AppModule](../lib/app/app_module.dart).

| Rota atual | Tela / comportamento | Migração |
| --- | --- | --- |
| `/` | Home; argumento opcional `showLogin` | Pública, com login acessível |
| `/places/create` | Criar/editar estabelecimento | Parceiro; edição atual depende de navegação |
| `/places/manage` | Gerenciar locais | Restaurar sessão e lista do parceiro |
| `/places/menu` | Cardápio; local opcional via objeto | Recuperar seleção após refresh |
| `/events/create` | Criar/editar evento | Autenticado; recuperar edição por ID |
| `/minha-area` | Perfil, histórico e preferências | Autenticado |
| `/place` | Detalhes por objeto PlaceEntity | Sem objeto, oferecer retorno/seleção |
| `/place/:param` | Local por ID ou slug | Preservar URL |
| `/places/:id` | Alias de detalhes de local | Preservar ou redirecionar para canônica |
| `/partner-dashboard` | Painel, com local opcional | Parceiro; seleção recuperável |
| `/events/:id` | Evento por ID ou slug | Preservar URL |

Links públicos atuais: `https://entaobora.com.br/place/{slugOuId}` e `https://entaobora.com.br/events/{slugOuId}`. Fonte: [PublicUrlHelper](../lib/shared/helpers/public_url_helper.dart).

Proposta de novas URLs: `/events/:id/edit`, `/places/:id/edit` e `?placeId=...` em cardápio/painel. Elas ainda não existem. Preservar links antigos, abertura direta, refresh e histórico do navegador. Evitar ambiguidade entre rotas estáticas (`create`, `manage`, `menu`) e parâmetros.

Resolver primeiro por ID, depois por slug, como nos datasources atuais. Depois da resolução, usar o **ID real do documento** em toda escrita e consulta de interações.

## 4. Funcionalidades e regras

### Home e mapa

Fontes: `lib/feature/home/presentation/`, especialmente `home_viewmodel.dart`, `map_section.dart` e `map_markers.dart`.

- Carrega locais e eventos; mantém assinatura dos eventos publicados ainda não encerrados.
- Centro inicial no Rio de Janeiro: `-22.9068, -43.1729`, zoom `11`.
- Marcadores incluem estabelecimentos e eventos sem `placeId`. Eventos vinculados são acessados a partir do estabelecimento.
- Agrupa itens na mesma posição e abre lista de seleção. Preservar navegação para detalhes e enquadramento do mapa.
- Ativar localização na home altera estado local; não equivale à preferência persistida da área pessoal.
- Reproduzir carregamento, estado vazio, erro e permissão negada; encerrar assinaturas ao sair.

### Autenticação e acesso

Fontes: `lib/feature/auth/`, [UserRole](../lib/shared/enum/user_role.dart) e viewmodels de gestão.

Login Google usa popup no web. Primeiro login cria `users/{uid}`; próximos logins atualizam nome/e-mail/foto/anonimato preservando papel e preferências. Há método de autenticação anônima, mas não foi comprovada uma jornada completa de perfil persistido para ele.

Papéis: `user`, `partner`, `admin`; valor desconhecido vira `user`. Criar evento exige usuário carregado, sem exigência de parceiro no viewmodel. Criar/gerenciar locais, cardápio e dashboard exige `isPartner`. `admin` não é automaticamente parceiro. `active` existe, mas não foi identificada aplicação uniforme de bloqueio nos fluxos examinados.

Locais/eventos do parceiro consideram `user.id` e `partnerId`, se preenchido, deduplicando por ID. Proposta: centralizar políticas e distinguir sessão carregando de deslogado. Definir explicitamente acesso de admin, inativo, autor e parceiro vinculado; verificar autorização no backend, além da interface. Regras implantadas não estão disponíveis no repositório.

### Eventos, Bora e check-in

Fontes: `lib/feature/events/presentation/viewmodels/` e [EventDatasourceImpl](../lib/feature/events/data/data_source/events_datasource_impl.dart).

Formulário: título, descrição, capa, local cadastrado ou endereço avulso, início/término, gêneros, atrações, ingresso, Instagram e galeria. Ao selecionar estabelecimento, nome/endereço são copiados para o evento; são um snapshot, sem atualização automática quando o local muda.

Validações atuais: título/descrição, capa, local/endereço, início/término, término não anterior ao início, ingresso externo HTTP/HTTPS, slug não vazio/duplicado. Datas iguais passam pela comparação atual, embora a mensagem sugira término maior. Definir esse limite para a migração.

Novo evento é `published`. Edição preserva autor, criação, status e contadores. DTO sem status usa `draft`, o que não é o padrão de criação. Estados possíveis: `draft`, `published`, `cancelled`, `finished`, `hidden`; não assumir interface completa para todas as transições.

Detalhes carregam local associado e incrementam views uma vez por ID durante a vida da instância do viewmodel, sem representar usuários únicos. Preservar compartilhamento e incremento de shares; definir o momento em que a ação conta.

**Bora:** exige login; alterna `boras/{uid}` e `boraCount` em transação. Atualmente confia no booleano da interface sem ler existência do documento. Proposta: ler o documento dentro da transação para evitar divergência entre abas e cliques repetidos.

**Check-in:** exige login, período do evento, ausência de check-in e distância de até **100 metros** do endereço. Salva coordenadas e horário. O botão usa comparações estritas; a ação rejeita apenas antes/depois, gerando diferença nos instantes exatos de início/fim. Unificar o limite. A transação atual incrementa sem ler existência prévia: garantir idempotência na persistência, não apenas na interface. Definir também como horário/proximidade serão verificados no backend.

### Estabelecimentos e cardápio

Fontes: `lib/feature/places/presentation/` e `lib/feature/menu_management/presentation/`.

Cadastro de local: nome, descrição, endereço/número/complemento, tipo, gêneros, contatos, horários e fotos. Valida nome, descrição, endereço, pelo menos um gênero e slug; exige parceiro ao salvar. Detalhes públicos mostram informações, fotos, proprietário, links externos, próximos eventos e cardápio em painel/modal.

Cardápio possui itens e categorias em arrays no documento do local. Gerenciamento inclui criar/editar/remover item e criar categoria, rejeitando duplicata e usando `Geral` como categoria padrão. Não assumir exclusão/renomeação de categoria como requisito existente sem validar o fluxo.

Proposta: preço numérico no banco, moeda brasileira na tela e validações de campos/preço/imagem. Atualizar campos necessários e tratar edições simultâneas, evitando sobrescrever dados com um objeto de local desatualizado.

### Dashboard e área pessoal

Fontes: [PartnerDashboardViewModel](../lib/feature/partner_dashboard/presentation/viewmodels/partner_dashboard_viewmodel.dart) e [UserAreaViewModel](../lib/feature/user_area/presentation/viewmodels/user_area_viewmodel.dart).

Dashboard soma views/Boras/check-ins, lista eventos por criador e transfere evento a usuário existente por ID, alterando `createdBy` e `updatedAt`. No Flutter atual, selecionar local inclui os eventos vinculados a ele e os eventos avulsos carregados para `user.id`/`partnerId` (`placeId` nulo, vazio ou espaços). Sem locais, os eventos carregados continuam acessíveis. Transferência não altera `placeId`. Contrato atualizado e pendências do React: [Área do parceiro — Flutter → React](AREA_PARCEIRO_FLUTTER_REACT.md).

Área pessoal reúne perfil, Boras, check-ins e preferências. Atividade recente deduplica eventos, ordena por `startDate` decrescente e limita a cinco; não usa horário da interação. Desativar localização muda o booleano, preservando coordenadas no banco.

## 5. Contratos de dados

São contratos observados nos DTOs, não uma auditoria do banco. `Timestamp` e `GeoPoint` são tipos Firestore. Converter datas explicitamente entre persistência e domínio React; preservar instantes, não gravar strings no lugar de Timestamp. Evitar `undefined` nas escritas.

```text
users/{uid}
  notification_tokens/{base64UrlDoToken}
places/{placeId}
events/{eventId}
  boras/{uid}
  checkins/{uid}
```

`places.ownerId` e `events.createdBy` referenciam usuários; `events.placeId` referencia local ou é nulo. Constantes `comments`, `favorites` e `presences` não comprovam jornadas ativas.

### Usuário

Fonte: [UserSummaryDto](../lib/feature/auth/data/dtos/user_summary_dto.dart).

| Campo | Tipo e observação |
| --- | --- |
| id, name | string; ID corresponde ao UID |
| email, photoUrl, partnerId | string ou null |
| isAnonymous | boolean, fallback false |
| role | user / partner / admin; fallback user |
| active | boolean, fallback true |
| notificationsEnabled, locationSharingEnabled | boolean, fallback false |
| lastKnownLocation | GeoPoint opcional |
| notificationUpdatedAt, locationUpdatedAt | Timestamp dos respectivos serviços |

Token: `{ token, platform, isWeb, enabled, updatedAt }`; strings, booleanos e Timestamp. ID é Base64 URL-safe do token; preservar comportamento de padding para não duplicar registros legados.

### Estabelecimento

Fonte: [PlaceDto](../lib/feature/places/data/dtos/place_dto.dart).

| Campo | Tipo e observação |
| --- | --- |
| id, slug, name, description | string; slug ausente vira vazio |
| address | Address abaixo |
| type | bar, pub, restaurant, brewery, concertHall, club, festival, square, other |
| phone, instagram, website | contatos; adaptar ausência legada |
| photos | string[] |
| ownerId | escrita string; leitura também aceita mapa `{id}` |
| musicGenres | string[] de valores do enum |
| openingHours | `{weekday, opensAt: {hour, minute}, closesAt: {hour, minute}}[]` |
| menuItems | `{id, title, description, price, photo, category}[]` |
| menuCategories | string[] |

Preço é número. Categoria ausente usa `Geral`. Dias: monday, tuesday, wednesday, thursday, friday, saturday, sunday. `00:00`–`23:59` representa 24 horas no legado. Definir exibição de horários que cruzam meia-noite.

### Evento

Fonte: [EventDto](../lib/feature/events/data/dtos/event_dto.dart).

| Campo | Tipo e observação |
| --- | --- |
| slug, title, description, locationName | string |
| placeId | string ou null |
| address | Address |
| startDate, endDate, createdAt, updatedAt | Timestamp |
| coverImage | string |
| gallery, musicGenres | string[] |
| attractions | `{id, name, instagram?, image?, isHeadliner}[]` |
| ticket | `{type: 'free' ou 'external', ticketUrl: string ou null}` |
| instagram | string ou null |
| boraCount, checkinCount, views, shares | inteiros; fallback zero |
| createdBy | escrita string UID; leitura também aceita mapa com id |
| status | draft, published, cancelled, finished, hidden |

ID vem do documento; `EventDto.toMap()` não grava `id`. `isBora` e `hasCheckedIn` são derivados por usuário, não campos globais. Criador ausente/inexistente faz o datasource omitir ou retornar nulo para o evento; tratar dados órfãos separadamente de falhas de rede.

### Objetos compartilhados e interações

[AddressDto](../lib/core/location/data/dtos/address_dto.dart) grava `displayName`, `latitude`, `longitude` e campos opcionais `street`, `number`, `complement`, `neighborhood`, `city`, `state`, `country`, `postalCode`. Coordenadas numéricas ficam na raiz de address; `address.location` é estrutura de domínio Dart, não de persistência.

Gêneros: classicRock, hardRock, heavyMetal, thrashMetal, deathMetal, blackMetal, powerMetal, doomMetal, punk, hardcore, grunge, indie, alternative, blues, jazz, popRock, nacional, coverBand, autoral, other. Manter valores e traduzir somente labels; desconhecidos viram other.

Bora: `{eventId, user: UserSummary, createdAt: Timestamp}`. Check-in: `{eventId, user: UserSummary, checkedInAt: Timestamp, latitude, longitude}`. `user` é snapshot do DTO completo e consultas pessoais usam `user.id`. Qualquer redução desse snapshot deve preservar a consulta e avaliar quais dados precisam ser expostos.

### Consultas existentes

| Fluxo | Consulta |
| --- | --- |
| Home/stream | status == published; endDate >= agora; ordenar endDate |
| Eventos do local | placeId == id; status == published; endDate >= agora; ordenar startDate |
| Slug de evento/local | slug == valor; limite 1 |
| Eventos por autor | unir createdBy == uid e createdBy.id == uid |
| Locais por proprietário | unir ownerId == uid e ownerId.id == uid |
| Atividade pessoal | collection group boras/checkins; user.id == uid; eventos ordenados por início decrescente |
| Usuários por IDs | consultas em lotes por ID no datasource |

Obter e versionar índices/regras implantados; não foram encontrados arquivos correspondentes. Validar consultas compostas e collection groups em homologação. A data limite do stream é fixada na criação da consulta: renovar/filtar por tempo para remover eventos encerrados sem novas escritas. Reduzir consultas repetidas de criador/interações por card com carregamento agrupado e cache controlado.

## 6. Integrações e ambiente

### Firebase e configuração

Referências: `lib/firebase_options.dart`, `firebase.json`, `web/firebase-messaging-sw.js`. Projeto identificado: `entaobora`. Confirmar aplicações e ambiente no console; separar homologação e produção.

Proposta: módulo único do SDK Web e adaptadores Auth/Firestore/FCM. Operações relacionadas usam transação/batch; consultar as garantias e reexecução em [Firestore: transações](https://firebase.google.com/docs/firestore/manage-data/transactions).

Configurações atuais: `GOOGLE_MAPS_API_KEY`, `GOOGLE_MAPS_MAP_ID` e `FCM_WEB_VAPID_KEY` via `String.fromEnvironment`. `web/index.html` também carrega Maps com chave literal; unificar configuração. `pubspec.yaml` declara `.env` como asset, mas o main examinado não carrega dotenv.

Proposta de `.env.example` para Vite: VITE_FIREBASE_API_KEY, VITE_FIREBASE_AUTH_DOMAIN, VITE_FIREBASE_PROJECT_ID, VITE_FIREBASE_STORAGE_BUCKET, VITE_FIREBASE_MESSAGING_SENDER_ID, VITE_FIREBASE_APP_ID, VITE_FIREBASE_MEASUREMENT_ID (se usado), VITE_GOOGLE_MAPS_API_KEY, VITE_GOOGLE_MAPS_MAP_ID, VITE_FCM_WEB_VAPID_KEY e VITE_PUBLIC_BASE_URL. Esses nomes ainda não existem no projeto.

Configurações no frontend são públicas; credenciais administrativas ficam fora dele. Verificar restrições das chaves e APIs habilitadas. Gerar configuração consistente para app/worker no build; não presumir substituição de variáveis em arquivos estáticos de public.

### Mapas e localização

`lib/core/location/data/data_source/location_data_source_impl.dart` chama Places Autocomplete/Details, Geocoding e reverse geocoding. `fromNominatim` em um DTO não torna Nominatim o provedor ativo. Centralizar integração e preservar componentes do endereço, incluindo número/complemento. Tratar resposta vazia, erro, permissão negada, cancelamento de busca e redução de chamadas de detalhes por sugestão.

### Imagens

[ImageHelper](../lib/shared/helpers/image_helper.dart) comprime qualidade 90 até 20 em passos de 10 e compara comprimento Base64 a `1048487`. O teste por imagem não mede o documento agregado com galeria/cardápio.

Proposta: renderizador compatível com Base64 legado e URL. Migrar novos uploads para Storage em etapa própria, com regras, erros, inventário e compatibilidade comprovados. Não reescrever imagens antigas sem backup e verificação de todos os consumidores.

### Notificações

[NotificationService](../lib/feature/notifications/data/notification_service.dart) pede permissão, obtém token VAPID no web e grava token/preferência em batch. Desativação marca preferência e token atual desabilitados; não desativa todos os dispositivos. Encerra o listener de renovação.

Implementar ciclo próprio do SDK Web, detecção de suporte e service worker acessível. Não transpor listener Dart literalmente. Ver [FCM para aplicações web](https://firebase.google.com/docs/cloud-messaging/web/get-started). Não há serviço de envio comprovado neste repositório: registro de token não garante entrega ponta a ponta.

## 7. Arquitetura React proposta

React + TypeScript, roteamento web, serviços Firebase e organização por feature. Vite é uma opção para manter SPA; a documentação oficial explica esse caminho e os limites de renderização no servidor: [React: aplicação do zero](https://react.dev/learn/build-a-react-app-from-scratch). Se SEO e previews por evento/local forem requisitos de lançamento, decidir SSR/pré-renderização antes de fixar arquitetura; HTML único não garante esses resultados.

```text
react-web/
  public/                 # ícones, manifest, worker
  src/
    app/                  # router, providers, layout, políticas
    features/
      auth/
      home/
      events/
      places/
      menu-management/
      partner-dashboard/
      user-area/
      notifications/
    core/
      firebase/           # inicialização, conversores, repositórios
      location/           # posição, busca, distância
    shared/
      ui/                 # botões, campos, cards, modal, skeleton
      styles/             # tokens e estilos globais
      models/             # contratos e enums
      utils/              # slug, datas, moeda, imagem, URLs
```

Pasta proposta, ainda não criada. Separar componentes, hooks, regras puras e persistência; não traduzir `.g.dart`, pois são arquivos gerados.

| Atual | Proposto |
| --- | --- |
| Modular | Router, layouts, módulos de serviços/providers |
| SessionStore/AuthViewModel | Provider e hook de sessão |
| ViewModel MobX | Hook da feature, estado local/reducer |
| DTO/repository | Tipos TypeScript, conversores, repositórios |
| Stream Firestore | Assinatura com cleanup |
| Form/validators | Formulários acessíveis e regras de domínio |
| BottomSheet/Dialog | Drawer/modal com foco e teclado |
| Share/url_launcher | Adaptadores de compartilhamento/links |
| Intl Dart | Formatação pt-BR de data/moeda |

Funções testáveis sugeridas: resolvePublicEntity, normalizeSlug, canCheckIn, distanceInMeters, parseEvent, parsePlace e políticas de acesso. Separar dados remotos do formulário; limpar dados pessoais/cache ao mudar usuário e cancelar listeners/respostas obsoletas ao desmontar.

### Componentes e identidade visual

Portar app bar/drawer, cards de evento/local, chips de gêneros, Bora/check-in, autocomplete, datas, horários, upload, cardápio público, métricas e skeletons. Referências: `lib/shared/design_system/` e widgets de cada feature.

Tokens: fundo #000000, superfície #161616, sheet #111111, primária #1F1F1F, destaque #D64545, sucesso #2E7D32, aviso #FFC107; texto branco/opacidades. Espaçamentos 4/8/12/16/20/24/32/36. Conteúdo máximo 1200, formulário 1100; heroes de local/evento 320/360.

Reutilizar assets e ícones; comparar telas lado a lado durante implementação. Cobrir mobile/desktop, teclado, foco, labels, alternativas textuais e mensagens de erro. Datas devem preservar o instante do banco; definir fuso de exibição, pois o legado usa horário local do dispositivo.

## 8. Riscos e decisões pendentes

| Prioridade | Evidência | Ação para migração |
| --- | --- | --- |
| Alta | Regras/índices/backend de envio ausentes aqui | Obter configuração implantada e homologação |
| Alta | Bora/check-in sem leitura transacional de existência | Garantir consistência e idempotência |
| Alta | getEventById resolve slug, mas consulta interações pelo argumento original | Usar entity.id após resolução |
| Alta | Admin/active/transferência sem política uniforme demonstrada | Definir e testar autorização |
| Alta | Base64 e limite apenas por imagem | Inventariar e planejar Storage compatível |
| Média | createdBy/ownerId em formatos múltiplos | Leitura dupla e escrita canônica |
| Média | Unicidade de slug consultada antes da escrita | Resolver concorrência, preservar links publicados |
| Média | React exclui eventos avulsos e esconde eventos quando não há locais | Parear com Flutter: incluir avulsos nas seleções e manter eventos acessíveis sem local cadastrado |
| Média | Limite temporal do stream fixo | Renovar consulta/filtro com tempo |
| Média | deleteEvent remove só documento principal | Definir limpeza/retenção de interações e arquivos |
| Média | Rotas dependem de objeto em memória | Adotar edição e seleção recuperáveis por URL |
| Média | Poucos testes | Cobrir contratos e jornadas críticas |

[migrate_slugs.dart](../tool/migrate_slugs.dart) analisa locais/eventos com DRY_RUN=true por padrão. Revisar colisões e backup antes de escrita. Nenhuma migração de dados foi executada nesta documentação.

## 9. Etapas e critérios de aceite

| Etapa | Entrega | Aceite |
| --- | --- | --- |
| 0. Baseline | Ambiente, regras, índices, amostras sanitizadas e telas | Matriz de acesso e jornadas revisadas |
| 1. Fundação | React, tipos, Firebase, router, design system | Build reproduzível, sessão restaurada e deep links |
| 2. Leitura pública | Home/mapa, locais, eventos, cardápio | Mesmos IDs/slugs/dados; estados de erro/vazio e layout comparado |
| 3. Interações | Login, Bora, check-in, views, share | Concorrência, tempo e distância testados |
| 4. Gestão | Locais, eventos, cardápio, dashboard, transferência | CRUD e vínculos corretos; escrita não autorizada bloqueada |
| 5. Área pessoal | Histórico, localização e FCM | Preferências persistem, troca de sessão limpa dados e push testado |
| 6. Publicação | Homologação, cache e rollback | Regressão aprovada e retorno ensaiado |

### Matriz mínima de validação

- Contratos: Timestamp, GeoPoint, endereço, opcionais, enums desconhecidos, autores/proprietários string/mapa e imagens Base64/URL.
- Slugs: transportar `test/slug_helper_test.dart`; testar acentos, espaços, pontuação, vazio, colisões e links após edição.
- Sessão: popup cancelado, primeiro login, restauração, logout, troca de usuário e preservação de papel/preferências.
- Eventos: local/avulso, ingresso inválido, datas iguais/invertidas, criador órfão e erro parcial.
- Bora: incluir/remover, clique repetido, duas abas e erro de rede; contagem igual aos documentos persistidos.
- Check-in: antes/durante/depois, instantes limite, 99/100/101 metros, permissão negada e solicitações simultâneas.
- Acesso: usuário, parceiro proprietário/vinculado/sem vínculo, admin e inativo conforme política; tentativa direta de escrita sem autorização.
- Cardápio: criar/editar/remover, categoria duplicada/Geral, preço e conflito de edição.
- Rotas: ID/slug, aliases, refresh, edição/menu, voltar, compartilhamento e não encontrado.
- FCM: suporte ausente, VAPID ausente, permitir/negar, token, desativação e mensagem foreground/background por emissor de teste.
- Publicação: cache Flutter antigo, build novo, deep links, asset ausente, worker e retorno ao build anterior.

Testes existentes: normalização de slug e criação de AppWidget; este último não monta nem percorre a aplicação. Proposta: testes unitários de domínio, integração de persistência/autorização em ambiente controlado e jornadas no navegador. Esta matriz não representa testes já executados.

## 10. Publicação e rollback

`firebase.json` tem rewrite geral para /index.html, mas não define diretório público de build. Configurar saída React explicitamente, preservando domínio/URLs. Primeiro homologar com dados de teste, domínios de autenticação, mapas, HTTPS e worker.

Planejar transição de caches/workers Flutter já instalados sem remover indiscriminadamente o worker FCM. Arquivar artefato Flutter servido e configuração antes da troca. Manter escrita retrocompatível durante coexistência; mudanças de esquema exigem backup e plano de dados separado.

Depois da troca, acompanhar erros de autenticação, consultas, permissões, contadores, mapas e notificações. Em regressão crítica, restaurar artefato/configuração anterior. Reverter frontend não desfaz gravações no banco.

Concluir quando jornadas acordadas, links antigos, contratos e políticas de acesso estiverem validados e o rollback ensaiado. Prazo depende das decisões de escopo, acesso à infraestrutura e lacunas registradas.
