import 'package:flutter/material.dart';
import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:remote_data_kit_example/character_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterRepositoryImpl _repository = CharacterRepositoryImpl();

  List<Character> _characters = <Character>[];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final Result<List<Character>> result =
        await _repository.getCharacters(name: _query);

    if (!mounted) {
      return;
    }

    switch (result) {
      case Success<List<Character>>(:final List<Character> data):
        setState(() {
          _characters = data;
          _isLoading = false;
        });
      case Failure<List<Character>>(:final ApiException error):
        setState(() {
          _errorMessage = error.message;
          _isLoading = false;
        });
    }
  }

  void _search(String value) {
    _query = value;
    _load();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String? errorMessage = _errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(errorMessage),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    if (_characters.isEmpty) {
      return const Center(child: Text('Sin resultados'));
    }

    return ListView.builder(
      itemCount: _characters.length,
      itemBuilder: (BuildContext context, int index) {
        return CharacterTile(character: _characters[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('remote_data_kit')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: 'Buscar por nombre y pulsar Enter',
              leading: const Icon(Icons.search),
              onSubmitted: _search,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
