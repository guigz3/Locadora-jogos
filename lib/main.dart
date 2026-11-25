import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locadora de Jogos',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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

// ---------- TELA DE LISTAGEM ----------
class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final List<Jogo> jogos = [];

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
    setState(() => jogos.removeAt(indice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locadora de Jogos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
      ),
      body: jogos.isEmpty
          ? const Center(child: Text('Nenhum jogo cadastrado'))
          : ListView.builder(
        itemCount: jogos.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(jogos[i].titulo),
            subtitle: Text('${jogos[i].plataforma} • ${jogos[i].genero}'),
            onTap: () => _abrirForm(i),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _excluir(i),
            ),
          );
        },
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jogo == null ? 'Novo jogo' : 'Editar jogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titulo,
                decoration: const InputDecoration(labelText: 'Jogo'),
                validator: _obrigatorio,
              ),
              TextFormField(
                controller: _plataforma,
                decoration: const InputDecoration(labelText: 'Plataforma'),
                validator: _obrigatorio,
              ),
              TextFormField(
                controller: _genero,
                decoration: const InputDecoration(labelText: 'Gênero'),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}