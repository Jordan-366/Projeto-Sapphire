import 'package:flutter/material.dart';
import 'tela-inicial.dart';
import 'cadastro_midia.dart';

class ChatAI extends StatefulWidget {
  const ChatAI({super.key});

  @override
  State<ChatAI> createState() => _ChatAIState();
}

class _ChatAIState extends State<ChatAI> {
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 34, 34),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0D53B8),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tela Inicial'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInicial()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat AI'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Cadastro de Mídia'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroMidia()),
                );
              },
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          'As mensagens do chat aparecerão aqui...',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      bottomSheet: Container(
        color: const Color.fromARGB(255, 41, 34, 34),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D53B8),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Digite sua mensagem...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}