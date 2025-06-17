import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/validators/credentials_carro_validator.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/usuario/editar/editar_carro_view_model.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class EditarCarroPage extends StatefulWidget {
  const EditarCarroPage({super.key});

  @override
  State<EditarCarroPage> createState() => _EditarCarroPageState();
}

class _EditarCarroPageState extends State<EditarCarroPage> {
  final viewModel = injector.get<EditarCarroViewModel>();

  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _corController = TextEditingController();
  final _placaController = TextEditingController();

  final validator = CredentialsCarroValidator();

  @override
  void initState() {
    super.initState();

    // Adiciona listeners para o ViewModel e para o comando de edição
    viewModel.addListener(_onViewModelChanged);
    viewModel.editarCarroCommand.addListener(_listenableEditar);

    // Inicializa os campos de texto (eles serão atualizados quando os dados carregarem)
    _updateTextFields();

    // Chama o método init do ViewModel para carregar os dados iniciais.
    // Usar addPostFrameCallback garante que isso ocorra após a primeira renderização.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Garante que o widget ainda está na árvore
        viewModel.init();
      }
    });
  }

  // Listener para quando o ViewModel notificar mudanças (ex: após _recarregarRotas)
  void _onViewModelChanged() {
    if (mounted) { // Garante que o widget ainda está na árvore
      _updateTextFields();
      // Se houver outras partes da UI que dependem diretamente do viewModel (ex: viewModel.usuario),
      // você pode precisar chamar setState(() {}) aqui para forçar uma reconstrução.
      // Para TextEditingControllers, a atribuição direta geralmente é suficiente.
    }
  }

  // Atualiza os TextEditingControllers com os dados do viewModel.credentials
  void _updateTextFields() {
    final credentials = viewModel.credentials;
    // Verifica se o texto é diferente para evitar atualizações desnecessárias e saltos do cursor
    if (_marcaController.text != credentials.marca) {
      _marcaController.text = credentials.marca;
    }
    if (_modeloController.text != credentials.modelo) {
      _modeloController.text = credentials.modelo;
    }
    if (_corController.text != credentials.cor) {
      _corController.text = credentials.cor;
    }
    if (_placaController.text != credentials.placa) {
      _placaController.text = credentials.placa;
    }
  }

  void _listenableEditar() {
    if (viewModel.editarCarroCommand.isSuccess) {
      final snackBar = SnackBar(
        content: Text("Carro editado com sucesso!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (viewModel.editarCarroCommand.isFailure) {
      final error = viewModel.editarCarroCommand.value as FailureCommand;
      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    // Remove os listeners para evitar memory leaks
    viewModel.removeListener(_onViewModelChanged);
    viewModel.editarCarroCommand.removeListener(_listenableEditar);

    // Descarta os controllers
    _marcaController.dispose();
    _modeloController.dispose();
    _corController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(greeting: "Editar Carro", isPop: true),
      body: SingleChildScrollView(
        primary: true,
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset("assets/logo/motorista.png", height: 150),
            ),
            const SizedBox(height: 20),

            Text("Marca do Carro", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _marcaController,
              decoration: _buildInputDecoration(hintText: 'Marca do carro'),
              onChanged: viewModel.setMarca,
              validator: (value) => validator.byField(
                viewModel.credentials,
                'marca',
              )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Modelo do Carro", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _modeloController,
              decoration: _buildInputDecoration(hintText: 'Modelo do carro'),
              onChanged: viewModel.setModelo,
              validator: (value) => validator.byField(
                viewModel.credentials,
                'modelo',
              )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Cor do Carro", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _corController,
              decoration: _buildInputDecoration(hintText: 'Cor do carro'),
              onChanged: viewModel.setCor,
              validator: (value) => validator.byField(
                viewModel.credentials,
                'cor',
              )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Placa do Carro", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _placaController,
              decoration: _buildInputDecoration(hintText: 'Placa do carro'),
              onChanged: viewModel.setPlaca,
              validator: (value) => validator.byField(
                viewModel.credentials,
                'placa',
              )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ), // Consistent rounding
                ),
              ),
              onPressed: () {
                if (validator.validate(viewModel.credentials).isValid) {
                  // Ao invés de acessar 'execute' diretamente como um getter,
                  // chame-o como um método se ele executar uma ação.
                  // Se 'execute' for um getter que retorna uma função, então chame a função:
                  // viewModel.editarCarroCommand.execute();
                  // Se 'execute' for um método que recebe os credentials:
                  // viewModel.editarCarroCommand.execute(viewModel.credentials);
                  // Pelo nome Command1(_editarCarro) e _editarCarro(CredentialsCarro credentials)
                  // o comando espera um argumento.
                  viewModel.editarCarroCommand.execute(viewModel.credentials);
                }
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    String? prefixText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[350]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  TextStyle get _labelStyle => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
  );
}