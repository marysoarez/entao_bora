# Home: referência React aplicada ao Flutter

Implementação baseada na especificação fornecida e no código local de `entao_bora_react/react-web`, em 15/09/2026.

## Organização

- `home.dart`: integra sessão, repositórios, autenticação e navegação.
- `home_explore.dart`: página rolável, cabeçalho, apresentação, busca, filtros, resultados, chamada e rodapé.
- `home_style.dart` e `home_icon_vectors.dart`: cores, tipografia, superfícies, controles e vetores Lucide.
- `home_result_cards.dart`: cards exclusivos da Home, sem modificar os cards das demais telas.
- `map_section.dart`: mapa padrão, agrupamento por coordenadas exatas, localização, carregamento, erro e nova tentativa.
- `map_seleton.dart`: skeleton com movimento reduzido.

Os arquivos `home_logo.png` e `home_brand.jpg` são cópias dos assets `public/logo.png` e `public/brand.jpg` do React.

## Comportamento

O estado inicial é Eventos + mapa. Busca, gênero e gratuitos permanecem ao trocar aba, visualização ou largura. A busca ignora caixa, preserva acentos e espaços das pontas. Eventos encerrados e não publicados são excluídos; a ordenação usa o término.

O mapa recebe os dois conjuntos filtrados e omite eventos vinculados a locais. Coordenadas iguais compartilham um marcador com quantidade. O grupo abre abaixo do mapa; um item único abre a rota de detalhes. A contagem continua sendo da aba ativa.

A localização centraliza o mapa com zoom 14 e mantém o rótulo Rio de Janeiro. Sem localização, o centro inicial é −22,9068 / −43,1729, zoom 11; múltiplas coordenadas usam ajuste de limites com padding 50. Não há estilo escuro nem camada de calor. O Map ID pode ser passado com `--dart-define=GOOGLE_MAPS_MAP_ID=...`.

Os dados são renovados a cada minuto. A assinatura dos eventos é recriada com o horário atual e a lista também verifica o término. Operações antigas não reiniciam assinaturas após a saída da página.

## Diferenças deliberadas e limites

- **Fonte:** Arial e Helvetica são solicitadas primeiro; Arimo acompanha o aplicativo como fallback. O projeto oficial descreve Arimo como compatível com as métricas de Arial. A fonte é distribuída com sua licença OFL e não depende de download em execução. [Descrição oficial](https://github.com/google/fonts/blob/main/ofl/arimo/DESCRIPTION.en_us.html), [licença](https://github.com/google/fonts/blob/main/ofl/arimo/OFL.txt).
- **Acessibilidade:** controles têm áreas de toque de pelo menos 44 × 48; cabeçalho e filtros podem quebrar em telas sem espaço ou com texto ampliado. O parceiro mantém um ícone com rótulo no mobile. Apenas o logotipo textual mantém proporções fixas; o conteúdo respeita a escala do sistema. Busca e cards mantêm indicação de foco.
- **Select:** usa o menu Flutter, pois o select nativo do navegador não é um componente Flutter. As opções e a ordem seguem o React.
- **Marcadores agrupados:** a API `Marker` do plugin não expõe o `label` do JavaScript. Grupos usam um bitmap de pin com número; marcadores individuais permanecem no padrão Google. A forma do pin agrupado pode diferir entre plataformas.
- **Nova tentativa:** erros dos dados recarregam os repositórios, preservando filtros e sessão, em vez de recarregar a página inteira. O mapa recria sua instância. Um prazo de 25 segundos evita skeleton permanente quando o SDK não chega ao primeiro `idle`.
- **Imagens:** falhas de download ou decodificação também exibem o placeholder, além dos campos ausentes.
- **Locais:** o repositório Flutter atual usa consulta e atualização periódica; não oferece assinatura em tempo real dos estabelecimentos.
- **Sem configuração:** `HomeExplore(configured: false)` representa o painel distinto de uma lista vazia e tem teste próprio. A inicialização geral do aplicativo continua exigindo a configuração Firebase existente em `main.dart`; este trabalho não altera o bootstrap para executar sem Firebase.

## Verificação

Suíte de widgets e viewmodel:

```powershell
flutter test --no-pub
```

Cobertura: 390, 760, 761, 768, 1250 e 1440 px; mapa inicial; listas em uma/três/duas colunas; persistência dos filtros; gênero e limpeza; ordenação; itens expirados; carregamento; erros coexistentes; nova tentativa; grupos e navegação por slug; localização concedida/negada; textos longos; escala 160% e 200%; atualização periódica e cancelamento após saída.

As capturas locais são geradas pelos testes, com dados de exemplo e SDK do mapa substituído. Para conferir Arial instalada no Windows sem distribuir a fonte proprietária:

```powershell
flutter test --no-pub --dart-define=HOME_PARITY_FONT=C:/Windows/Fonts/arial.ttf --dart-define=HOME_SCREENSHOTS=true test/home_explore_test.dart --plain-name 'capture home'
```

Saída em `build/home-parity/`: Home nas seis larguras; eventos, estabelecimentos e painel sem configuração em 390 e 1440. O processo carrega também Arial Bold, quando disponível junto à fonte regular.

As capturas verificam o layout Flutter. Não constituem comparação pixel a pixel com capturas React nem validação de Google Maps, permissões de localização ou autenticação em dispositivos reais. O emoji depende da fonte de emoji do dispositivo e pode aparecer como glifo ausente no renderizador de testes.

Também foram executadas análise estática dos arquivos alterados e compilação web. As licenças Arimo e Lucide são incluídas nos assets e registradas no `LicenseRegistry` do Flutter.
