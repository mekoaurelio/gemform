import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:gemform/services/utils.dart';
import 'package:gemform/services/Footer.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../widgets/custom_butom.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/texto.dart';
import '../data/firebase_service.dart';
import 'lista.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

//http://www.form.gem.net.br/arquivos/form.html

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _edNome = TextEditingController();
  final TextEditingController _edFone = TextEditingController();
  final TextEditingController _edCidade = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String txEnviar='Enviar';

  final phoneMask = MaskTextInputFormatter(
    mask: '##-#-####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );


  @override
  void dispose() {
    _edNome.dispose();
    _edFone.dispose();
    _edCidade.dispose();
    super.dispose();
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      final nome = _edNome.text;
      final fone = _edFone.text;
      final cidade = _edCidade.text;
      try {
        if(fone.length<14){
          Utils.nsBar(context, 'Celular Inválido', Colors.red);
          return;
        }
        if(txEnviar!='Enviar'){
          return;
        }
        var user= await FirebaseService.getUserPhone(fone);
        if (user != null && user.isNotEmpty) {
          Utils.nsBar(context, 'Celular já cadastrado', Colors.red);
          return;
        }
        setState(() {
          txEnviar='AGUARDE POR FAVOR. ENVIANDO DADOS';
        });
        await FirebaseService.salvarFormulario(
          nome,
          fone,
          cidade,
        );
        setState(() {
          txEnviar='DADOS ENVIADOS';
        });
       // Utils.nsBar(context, 'Obrigado por ter informado seus dados', Colors.green);
        mostraApresentacao();
      }  catch (e) {
        return null;
      }
    }
  }

  mostraApresentacao(){
    showDialog(
        context: context,
        barrierDismissible: false, // Impede que o popup feche ao clicar fora
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Obrigado por ter informado seus dados'),
            content: const Text('Pressione no botão abaixo para baixar a apresentação'),
            actions: [
              TextButton(
                onPressed: () async{
                  await downloadPdf();
                  Navigator.of(context).pop();
                },
                child: const Text('Baixar'),
              ),
            ],
          );
        }
    );
  }

  Future<void> downloadPdf() async {
    const url = "https://www.form.gem.net.br/arquivos/pdf.pdf";
    html.window.open(url, "_blank");
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF699A92),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isMobile) {
              return _buildMobileLayout();
            } else if (isTablet) {
              return _buildTabletLayout();
            } else {
              return _buildDesktopLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Imagem no topo para mobile
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/robo_login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Formulário de login
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: _buildLoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return InkWell(
        onTap: () {
          Get.to(() => Lista(), arguments: {}); // Call the builder function
        },
        child:Row(
          children: [
        // Imagem na lateral esquerda
        Expanded(
          flex: 1,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/robo_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Formulário de login
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: _buildLoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    )

    );
  }

  Widget _buildDesktopLayout() {
    return InkWell(
        onTap: () {
          Get.to(() => Lista(), arguments: {}); // Call the builder function
        },
        child: Row(
      children: [
        // Imagem na lateral esquerda
        Container(
          width: 600,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/robo_login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 50),
        // Formulário de login
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildLoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    )
    );
  }

  Widget _buildLoginForm() {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Texto(
              tit: 'Bem vindo(a) ao GEM',
              bottom: isMobile ? 20 : 40,
              negrito: true,
              tam: isMobile ? 16 : 40,
            ),
            //NOME
            CustomTextFiel(
              controller: _edNome,
              label: 'Qual o seu Nome',
              hintText: 'Informe o seu Nome',
              prefixIcon: Icons.perm_contact_cal,
              obrigatorio: true,
              bottom: 20,
            ),
            //TELEFONE
            CustomTextFiel(
              controller: _edFone,
              label: 'Número do seu celular',
              hintText: 'Qual o seu celular',
              prefixIcon: Icons.settings_cell,
              obrigatorio: true,
              bottom: 20,
              inputFormatters: [phoneMask],
            ),
            //CIDADE
            CustomTextFiel(
              controller: _edCidade,
              label: 'Sua cidade',
              hintText: 'Qual a sua cidade',
              prefixIcon: Icons.location_city,
              obrigatorio: true,
              bottom: 10,
            ),
            SizedBox(height: isMobile ? 15 : 20),
            AppButton(
              text: txEnviar,
              onPressed: _login,
              isLoading: _isLoading,
              backgroundColor: Color(0xFF699A92),
              textColor: Colors.white,
            ),
            SizedBox(height: isMobile ? 20 : 30),
            Footer(),
          ],
        ),
      ),
    );
  }
}


