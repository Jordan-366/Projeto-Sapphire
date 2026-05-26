import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'tela-inicial.dart';
import 'db_test.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await iniciarBanco();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

const String defaultSistemaId = "95bc4a2f-2fed-4aaf-81a5-3dc05b3dee6c";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  RegistroScreenState createState() => RegistroScreenState();
}

class RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  void _registrar() async {
    if (_nomeController.text.isEmpty ||
        _sobrenomeController.text.isEmpty ||
        _loginController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final success = await ApiService().register(
      name: _nomeController.text,
      surname: _sobrenomeController.text,
      login: _loginController.text,
      email: _emailController.text,
      password: _senhaController.text,
      sistemaId: defaultSistemaId,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro validado com sucesso')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no cadastro. Verifique os dados e tente novamente.')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _loginController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: const Color(0xFF0D53B8).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Cadastro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _nomeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _sobrenomeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Sobrenome',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _loginController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Login',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _isLoading
                  ? const SizedBox(
                      height: 48,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ElevatedButton(
                      onPressed: _registrar,
                      child: const Text('Registrar'),
                    ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem conta? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Entrar'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class TokenStorage {
  Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TapGestureRecognizer _cadastreseRecognizer = TapGestureRecognizer();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cadastreseRecognizer.onTap = () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegistroScreen()),
      );
    };
  }

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    _cadastreseRecognizer.dispose();
    super.dispose();
  }

  void _login() async {

    if (_loginController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final token = await ApiService().login(_loginController.text, _senhaController.text);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      // 4. salvar token
      await TokenStorage().save(token);
      // salvar usuário atual para banco por-usuario
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', _loginController.text);
      if (!mounted) return;

      // 5. navegar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaInicial()),
      );
    } else {
      // erro de login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login inválido')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: const Color(0xFF0D53B8).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20)
          ),//Borda arredondada
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              const Text(
                "Bem vindo!", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),
              ), //Texto bem vindo
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _loginController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Login",
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),//Entry do login/usuario
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  enabled: !_isLoading,
                  controller: _senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Senha",
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),   //Entry da senha 
              const Spacer(),
              _isLoading
                  ? const SizedBox(
                      height: 48,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
              const SizedBox(height: 10,),
              RichText(
                text: TextSpan(
                  text: 'Não tem conta? ',
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Cadastre-se',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: _cadastreseRecognizer,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ), // Fundo azul
      ),
    );
  }
}
