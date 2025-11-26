import 'dart:html' as html;
import 'package:excel/excel.dart';

Future<void> gerarPlanilha(List<Map<String, dynamic>> allData) async {
  final excel = Excel.createExcel();
  final sheet = excel['Leads'];

  // Cabeçalho principal
  sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("C1"));
  sheet.cell(CellIndex.indexByString("A1")).value = "Lista de Leeds";

  // Estilo para o cabeçalho principal
  final headerCell = sheet.cell(CellIndex.indexByString("A1"));
  headerCell.cellStyle = CellStyle(
    bold: true,
    fontSize: 16,
    horizontalAlign: HorizontalAlign.Center,
  );

  // Cabeçalho das colunas
  sheet.appendRow([]); // Linha vazia para separação
  sheet.appendRow(["Nome", "Telefone", "Cidade"]);

  // Estilo para os cabeçalhos das colunas
  final columnHeaders = ['A3', 'B3', 'C3'];
  for (var cellRef in columnHeaders) {
    final cell = sheet.cell(CellIndex.indexByString(cellRef));
    cell.cellStyle = CellStyle(
      bold: true,
      backgroundColorHex: "#D3D3D3", // Cinza claro
      horizontalAlign: HorizontalAlign.Center,
    );
  }

  // Dados
  for (var item in allData) {
    sheet.appendRow([
      item['nome'] ?? "",
      item['fone'] ?? "",
      item['cidade'] ?? "",
    ]);
  }

  // Ajustar largura das colunas para mostrar todo o conteúdo
  sheet.setColAutoFit(0); // Coluna A (Nome)
  sheet.setColAutoFit(1); // Coluna B (Telefone)
  sheet.setColAutoFit(2); // Coluna C (Cidade)

  // Adicionar bordas às células com dados
  final dataStartRow = 4; // Linha onde começam os dados (após cabeçalhos)
  final dataEndRow = 3 + allData.length; // Linha final dos dados

  for (var row = dataStartRow; row <= dataEndRow; row++) {
    for (var col = 0; col < 3; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
      cell.cellStyle = CellStyle(
        //border: Border(borderStyle: BorderStyle.Thin, borderColorHex: "#000000"),
      );
    }
  }

  final fileBytes = excel.encode();

  if (fileBytes != null) {
    final blob = html.Blob([fileBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "leads.xlsx")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}