# Então Bora

Seu próximo rolé começa aqui.

Aplicação Flutter para descobrir estabelecimentos e eventos musicais no mapa, marcar interesse (Bora), fazer check-in e gerenciar eventos e cardápios. Utiliza Firebase Authentication, Cloud Firestore e Firebase Cloud Messaging.

## Documentação para migração

O [guia de migração de Flutter para React](docs/MIGRACAO_REACT.md) apresenta funcionalidades, rotas, regras de negócio, contratos de dados, integrações, arquitetura proposta, etapas e critérios de aceite.

A proposta considera **React para web**, preservando inicialmente Firebase e dados existentes. A migração ainda não foi implementada. A substituição dos aplicativos nativos exige escopo próprio.

## Estrutura atual

- `lib/app/`: dependências e rotas.
- `lib/feature/`: funcionalidades, apresentação, domínio e dados.
- `lib/core/`: Firestore, localização e tema.
- `lib/shared/`: componentes, design system, modelos e utilitários.
- `web/`: entrada web, manifest, ícones e service worker.
- `assets/images/`: imagens do projeto.
- `test/`: testes existentes.
- `tool/migrate_slugs.dart`: análise/preenchimento de slugs, com simulação por padrão.

## Executar o projeto Flutter

O pubspec exige Dart `^3.9.2`. Use Flutter compatível e configure Firebase e APIs de mapas conforme o guia. O manifesto declara `.env` como asset; providencie o arquivo local caso esteja ausente, sem incluir segredos nele.

```sh
flutter pub get
flutter run -d chrome --dart-define=GOOGLE_MAPS_API_KEY=VALOR --dart-define=GOOGLE_MAPS_MAP_ID=VALOR --dart-define=FCM_WEB_VAPID_KEY=VALOR
flutter analyze
flutter test
```

Esses comandos são referências e não foram executados durante a documentação. O HTML atual também carrega uma chave de Maps diretamente; dart-define não substitui automaticamente essa configuração.
