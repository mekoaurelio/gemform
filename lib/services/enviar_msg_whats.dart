import 'dart:html' as html;

Future<void> enviarMensagensWhatsApp(
    List<Map<String, dynamic>> lista,
    String mensagemTemplate,
    ) async {

  for (var item in lista) {
    final nome = item['nome'] ?? '';
    final fone = item['fone'] ?? '';

    // Remover caracteres não numéricos do telefone
    final telefone = fone.replaceAll(RegExp(r'[^0-9]'), '');

    if (telefone.isEmpty) continue;

    // Personalizar mensagem usando {nome}
    final msg = mensagemTemplate.replaceAll('{nome}', nome);

    final url =
        "https://wa.me/55$telefone?text=${Uri.encodeComponent(msg)}";

    html.window.open(url, "_blank");

    // Delay de 600ms entre abas para evitar bloqueio do navegador
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
