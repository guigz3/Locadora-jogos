import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locadora de Jogos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F1FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.deepPurple.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
      home: const ListaPage(),
    );
  }
}

// ---------- MODELO ----------
class Jogo {
  final String titulo;
  final String plataforma;
  final String genero;

  Jogo(this.titulo, this.plataforma, this.genero);
}

// ---------- CABEÇALHO COM GRADIENTE ----------
PreferredSizeWidget _appBar(String titulo, {bool voltar = false}) {
  return AppBar(
    title: Text(
      titulo,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: voltar,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4527A0), Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}

// ---------- TELA DE LISTAGEM ----------
class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final List<Jogo> jogos = [];

  static const List<Color> _cores = [
    Color(0xFF5E35B1),
    Color(0xFF00897B),
    Color(0xFFE64A19),
    Color(0xFF1E88E5),
    Color(0xFFD81B60),
    Color(0xFF7CB342),
  ];

  Future<void> _abrirForm([int? indice]) async {
    final resultado = await Navigator.push<Jogo>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPage(jogo: indice == null ? null : jogos[indice]),
      ),
    );

    if (resultado == null) return; // voltou sem salvar

    setState(() {
      if (indice == null) {
        jogos.add(resultado); // cadastro
      } else {
        jogos[indice] = resultado; // edição
      }
    });
  }

  void _excluir(int indice) {
    final nome = jogos[indice].titulo;
    setState(() => jogos.removeAt(indice));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$nome" removido'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sports_esports,
              size: 72,
              color: Colors.deepPurple.shade300,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nenhum jogo cadastrado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Toque em "Novo jogo" para começar',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _cardJogo(int i) {
    final jogo = jogos[i];
    final cor = _cores[i % _cores.length];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _abrirForm(i),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cor,
                child: Text(
                  jogo.titulo[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogo.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _chip(Icons.devices, jogo.plataforma, cor),
                        _chip(Icons.category, jogo.genero, cor),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Excluir',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _excluir(i),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icone, String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar('Locadora de Jogos'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: const Text('Novo jogo'),
      ),
      body: jogos.isEmpty
          ? _estadoVazio()
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: jogos.length,
        itemBuilder: (context, i) => _cardJogo(i),
      ),
    );
  }
}

// ---------- TELA DE FORMULÁRIO ----------
class FormPage extends StatefulWidget {
  final Jogo? jogo; // null = cadastro | preenchido = edição
  const FormPage({super.key, this.jogo});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo =
  TextEditingController(text: widget.jogo?.titulo);
  late final TextEditingController _plataforma =
  TextEditingController(text: widget.jogo?.plataforma);
  late final TextEditingController _genero =
  TextEditingController(text: widget.jogo?.genero);

  String? _obrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Jogo(_titulo.text.trim(), _plataforma.text.trim(), _genero.text.trim()),
    );
  }

  @override
  void dispose() {
    _titulo.dispose();
    _plataforma.dispose();
    _genero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.jogo != null;

    return Scaffold(
      appBar: _appBar(editando ? 'Editar jogo' : 'Novo jogo', voltar: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        editando ? Icons.edit_note : Icons.sports_esports,
                        size: 52,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        editando
                            ? 'Altere os dados do jogo'
                            : 'Preencha os dados do jogo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _titulo,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Jogo',
                          prefixIcon: Icon(Icons.videogame_asset),
                        ),
                        validator: _obrigatorio,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _plataforma,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Plataforma',
                          prefixIcon: Icon(Icons.devices),
                        ),
                        validator: _obrigatorio,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _genero,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _salvar(),
                        decoration: const InputDecoration(
                          labelText: 'Gênero',
                          prefixIcon: Icon(Icons.category),
                        ),
                        validator: _obrigatorio,
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save),
                          label: const Text(
                            'Salvar',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}