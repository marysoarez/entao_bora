class ImageTooLargeException implements Exception {
  final String message;

  ImageTooLargeException([
    this.message =
        'A imagem é muito grande. Escolha uma imagem menor ou com menor resolução.',
  ]);
}