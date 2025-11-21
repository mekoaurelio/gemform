import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static bool _initialized = false;

  static late FirebaseFirestore firestore;

  /// Inicializa o Firebase e conecta ao banco 'easymenudb'
  static Future<void> init() async {
    if (_initialized) return;

    await Firebase.initializeApp();

    // 🔥 Conecta ao Firestore com databaseId específico
    firestore = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      //databaseId: 'form',
    );
    _initialized = true;
  }

  //PEGA OS DADOS DO USUÁRIO PELO EMAIL
  static Future<Map<String, dynamic>?> getUserPhone(String fone) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('form')
          .where('fone', isEqualTo: fone)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }


  /// Cria novo restaurante no Firestore (banco easymenudb)
  static Future<DocumentReference> createRestaurant(Map<String, dynamic> data) {
    return firestore.collection('restaurants').add(data);
  }

  static Future<void> salvarFormulario(String nome, String fone, String cidade) async {
    try {
      // Cria um documento automático na coleção "form"
      await FirebaseFirestore.instance.collection('form').add({
        'nome': nome,
        'fone': fone,
        'cidade': cidade,
        'createdAt': FieldValue.serverTimestamp(), // opcional, mas útil
      });

      print("Dados salvos com sucesso!");
    } catch (e) {
      print("Erro ao salvar: $e");
    }
  }

}