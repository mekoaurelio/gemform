import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../widgets/texto.dart';

class Utils {

  static final formKeyListNotificacaoDetalhe = GlobalKey<FormState>();
  static final formatVr = NumberFormat("#,##0.00", "pt_BR");
  static var formatterD =  DateFormat('dd/MM/yyyy');
  static var formatterh =  DateFormat('hh:mm');


  static BoxDecoration decor() {
    return BoxDecoration(
      // color: Colors.blueGrey[100], // Cor de fundo do container
      border: Border.all(
        color: Colors.grey.shade300, // Cor da borda
        width: 1.0, // Espessura da borda
        style: BorderStyle.solid, // Estilo da borda (sólida, tracejada, etc.)
      ),
      borderRadius: BorderRadius.circular(
          10.0), // Opcional: bordas arredondadas
    );
  }

  static  borda(){
    return  const Border(
      bottom: BorderSide(
        color: Colors.white70  , // Cor da borda
        width: 0.2, // Espessura da borda
      ),
    );
  }

  static logo(String path){
    return Container(
      width: 312,
      height: 162.5,
      decoration: BoxDecoration(
        image:  DecorationImage(
          image: AssetImage(path),
          // fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        color: Color(0xFFEFE7DE),
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget line(var tex, double tam, [Alignment? alignment]) {
    return Container(
      width: tam,
      alignment: alignment ?? Alignment.center,
      child: Texto(
        tit: tex,
        cor: Colors.black,
        tam: 12,
        top: 10,
        bottom: 10,
      ),
    );
  }


  static nsBar(BuildContext context,var tit,Color corFundo){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tit,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: corFundo,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

}//441