import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  bool isLoading = false;
  int totalItems = 0;

  // --- CONFIGURAÇÕES DE PAGINAÇÃO ---
  int currentPage = 1;
  int itemsPerPage = 15;

  int get totalPages =>
      (filteredData.length / itemsPerPage).ceil().clamp(1, 999999);

  // Método para mudar página
  void changePage(int newPage) {
    if (newPage < 1 || newPage > totalPages) return;
    setState(() => currentPage = newPage);
  }

  // Lista de itens da página atual
  List<Map<String, dynamic>> get paginatedData {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > filteredData.length) end = filteredData.length;
    return filteredData.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(_applyFilter);
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    var snap = await FirebaseFirestore.instance
        .collection('form')
        .orderBy('createdAt', descending: true)
        .get();

    allData = snap.docs.map((d) {
      final data = d.data();
      return {
        'nome': (data['nome'] ?? '').toString(),
        'fone': (data['fone'] ?? '').toString(),
        'cidade': (data['cidade'] ?? '').toString(),
      };
    }).toList();

    setState(() {
      filteredData = List.from(allData);
      totalItems = allData.length;
      isLoading = false;
    });
  }

  void _applyFilter() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredData = allData.where((item) {
        final nome = item['nome'].toLowerCase();
        final telefone = item['fone'].toLowerCase();
        final cidade = item['cidade'].toLowerCase();

        return nome.contains(query) ||
            telefone.contains(query) ||
            cidade.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leeds Enviados"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(12),
              child:
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Buscar por nome, telefone ou cidade...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

            ),

          //LISTA
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey[200],
                        ),
                        columns: const [
                          DataColumn(label: Text("Nome")),
                          DataColumn(label: Text("Telefone")),
                          DataColumn(label: Text("Cidade")),
                        ],
                        rows: paginatedData.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['nome'])),
                              DataCell(Text(item['fone'])),
                              DataCell(Text(item['cidade'])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),

          // Rodapé
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width *0.44,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Ir para primeira página
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 1 ? () => changePage(1) : null,
                ),

                // Página anterior
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () => changePage(currentPage - 1)
                      : null,
                ),

                Text("Página $currentPage de $totalPages"),

                // Próxima página
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages
                      ? () => changePage(currentPage + 1)
                      : null,
                ),

                // Última página
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < totalPages
                      ? () => changePage(totalPages)
                      : null,
                ),

                const Spacer(),

                Text("${filteredData.length} Itens"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
