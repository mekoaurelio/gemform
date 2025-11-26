import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

Future<void> gerarPDF(List<Map<String, dynamic>> allData) async {
  final pdf = pw.Document();

  final totalItens = allData.length;
  final dataGeracao = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

  // --- Se quiser adicionar logo, descomente e adicione o base64 ---
   //final logo = pw.MemoryImage(
     //(await rootBundle.load('assets/images/robo_login.png')).buffer.asUint8List(),
   //);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(20),

      // ============================================================
      //   🔵 CABEÇALHO DO PDF
      // ============================================================
      header: (context) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey500, width: 1),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Se quiser logo, colocar aqui:
             //pw.Image(logo, width: 80),
            pw.Text(
              "Relatório de Leads",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.Text(
              "Gerado em: $dataGeracao",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),

      // ============================================================
      //   🔵 RODAPÉ COMO O DO APP
      // ============================================================
      footer: (context) => pw.Container(
        padding: const pw.EdgeInsets.only(top: 8),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: PdfColors.grey500, width: 1),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Página ${context.pageNumber} de ${context.pagesCount}",
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              "$totalItens itens",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),

      // ============================================================
      //   🔵 CONTEÚDO (TABELA PÁGINA A PÁGINA)
      // ============================================================
      build: (pw.Context context) {
        return [
          pw.SizedBox(height: 20),

          // 🔵 Tabela
          pw.Table.fromTextArray(
            headers: ["Nome", "Telefone", "Cidade"],
            data: allData.map((item) {
              return [
                item['nome'] ?? '',
                item['fone'] ?? '',
                item['cidade'] ?? '',
              ];
            }).toList(),
            cellStyle: const pw.TextStyle(
              fontSize: 10,
            ),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.blue800,
            ),
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300),
              ),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
          ),
        ];
      },
    ),
  );

  // Salvar e baixar no navegador
  final bytes = await pdf.save();
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "leads.pdf")
    ..click();

  html.Url.revokeObjectUrl(url);
}

