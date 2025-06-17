import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/validators/credentials_registrar_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/registrar/registrar_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class RegistrarPage extends StatefulWidget {
  const RegistrarPage({super.key});

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  final viewModel = injector.get<RegistrarViewModel>();
  final credentials = CredentialsRegistrar();
  final validator = CredentialsRegistrarValidator();

  final nomeCompletoController = TextEditingController();
  final nomeSocialController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  bool aceitoTermos = false;
  bool _cadastroConcluido = false;
  bool _exibirSenha = false;
  bool _exibirConfirmarSenha = false;

  Future<void> _selecionarDataNascimento() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      dataNascimentoController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(dataSelecionada);
      credentials.setDataNascimento(dataSelecionada);
    }
  }

  // NOVA FUNÇÃO: Exibe o modal com os Termos e Condições
  void _showTermsAndConditionsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Termos e Condições"),
          content: const SingleChildScrollView(
            child: Text(
              '''
Termos e Condições de Uso do CapyCar

Última atualização: 07 de Junho de 2024

Bem-vindo ao CapyCar!

Estes Termos e Condições de Uso ("Termos") regem o seu acesso e uso do nosso aplicativo de caronas universitárias, CapyCar ("Aplicativo"). Ao se cadastrar e utilizar o Aplicativo, você concorda em cumprir estes Termos. Leia-os com atenção.

1. O Serviço
O CapyCar é uma plataforma digital que conecta estudantes da Universidade Federal Rural do Rio de Janeiro (UFRRJ) que desejam oferecer ou buscar caronas. O serviço tem como objetivo facilitar a mobilidade, promover a sustentabilidade e fortalecer a comunidade acadêmica.

Importante: O CapyCar atua exclusivamente como um intermediário entre usuários, não sendo responsável pelas ações, decisões, comportamentos ou eventuais danos causados por qualquer usuário, dentro ou fora do Aplicativo.

2. Elegibilidade
Para usar o CapyCar, você deve:
a) Ser um membro ativo da comunidade da UFRRJ (aluno, professor ou técnico-administrativo).
b) Possuir um e-mail institucional (@ufrrj.br) válido para verificação.
c) Ter pelo menos 18 anos de idade.

3. Cadastro e Conta
a) Você concorda em fornecer informações precisas, atuais e completas durante o processo de registro.
b) A segurança da sua senha é de sua responsabilidade. Não compartilhe suas credenciais com terceiros.
c) Você é responsável por todas as atividades que ocorrem em sua conta.

4. Conduta do Usuário
a) Motoristas e Passageiros: Devem tratar-se com respeito e cortesia.
b) Segurança: A segurança é uma responsabilidade compartilhada. Motoristas devem manter seus veículos em boas condições e dirigir de forma segura. Passageiros devem adotar um comportamento prudente.
c) Compromisso: Ao aceitar uma carona (passageiro) ou um passageiro (motorista), você assume um compromisso. Cancelamentos devem ser feitos com a maior antecedência possível.
d) Proibições: É estritamente proibido usar o Aplicativo para fins ilegais, transportar itens ilícitos, assediar outros usuários ou se envolver em qualquer atividade fraudulenta.

5. Custos e Pagamentos
O CapyCar sugere um valor de contribuição para ajudar a cobrir os custos do motorista (combustível, manutenção, etc.). Este valor não tem finalidade lucrativa. Toda negociação e transação é de responsabilidade exclusiva dos usuários envolvidos.

O CapyCar não processa pagamentos e não se responsabiliza por valores acordados, recebidos ou não pagos.

6. Isenção de Responsabilidade
a) O CapyCar é uma ponte de conexão entre usuários e não exerce qualquer controle direto ou indireto sobre as caronas realizadas.
b) Não nos responsabilizamos por atrasos, acidentes, perdas, danos materiais ou morais, comportamentos inapropriados ou qualquer outro evento decorrente do uso do serviço.
c) Não verificamos a documentação dos veículos, a validade da CNH, nem o histórico dos motoristas ou passageiros.
d) O uso do Aplicativo e a decisão de participar de caronas ocorrem por conta e risco exclusivo dos usuários.

7. Privacidade
Nossa Política de Privacidade descreve como coletamos e usamos suas informações pessoais. Ao usar o CapyCar, você concorda com a coleta e o uso de informações de acordo com essa política.

8. Modificações nos Termos
Podemos modificar estes Termos a qualquer momento. Notificaremos sobre alterações significativas através do Aplicativo ou por e-mail. O uso contínuo do Aplicativo após as modificações constitui sua aceitação dos novos Termos.

9. Encerramento da Conta e Exclusão de Dados
Você pode solicitar o encerramento da sua conta e a exclusão de seus dados pessoais a qualquer momento, entrando em contato por e-mail.
Caso viole estes Termos, reservamo-nos o direito de suspender ou excluir sua conta sem aviso prévio.

Para suporte, dúvidas, ou solicitações de exclusão de conta e dados, envie um e-mail para: pabloliv429@ufrrj.br.

10. Aceite dos Termos
Ao clicar em "Aceito os termos e condições", você confirma que leu, compreendeu e concorda com os presentes Termos.
''',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    viewModel.registrarCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.registrarCommand.isSuccess) {
      setState(() {
        _cadastroConcluido = true;
      });
    } else if (viewModel.registrarCommand.isFailure) {
      final error = viewModel.registrarCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    nomeCompletoController.dispose();
    nomeSocialController.dispose();
    dataNascimentoController.dispose();
    emailController.dispose();
    celularController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    viewModel.registrarCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          children: [
            IconButton(
              iconSize: 30.0,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Routefly.navigate(routePaths.auth.login);
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child:
                _cadastroConcluido
                    ? _buildSucessoContent()
                    : _buildFormularioContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormularioContent() {
    return Column(
      children: [
        const Text(
          'Registre-se já',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: nomeCompletoController,
          onChanged: credentials.setNomeCompleto,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "nomeCompleto"),
          decoration: _buildInputDecoration('Nome Completo'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: nomeSocialController,
          onChanged: credentials.setNomeSocial,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "nomeSocial"),
          decoration: _buildInputDecoration('Nome Social (opcional)'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: dataNascimentoController,
          readOnly: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "dateOfBirth"),
          onTap: _selecionarDataNascimento,
          decoration: _buildInputDecoration(
            'Data de Nascimento',
          ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: emailController,
          onChanged: credentials.setEmailInstitucional,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "emailInstitucional"),
          decoration: _buildInputDecoration('Email Institucional @ufrrj'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: celularController,
          onChanged: credentials.setNumeroCelular,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "numeroCelular"),
          decoration: _buildInputDecoration('Celular(DDD + Número)'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: senhaController,
          onChanged: credentials.setSenha,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "senha"),
          obscureText: !_exibirSenha,
          decoration: _buildInputDecoration('Senha').copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                color: Colors.black,
                _exibirSenha ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _exibirSenha = !_exibirSenha;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextFormField(
          controller: confirmarSenhaController,
          onChanged: credentials.setConfirmarSenha,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "confirmarSenha"),
          obscureText: !_exibirConfirmarSenha,
          decoration: _buildInputDecoration('Confirme sua Senha').copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                color: Colors.black,
                _exibirConfirmarSenha ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _exibirConfirmarSenha = !_exibirConfirmarSenha;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // WIDGET MODIFICADO
        Row(
          children: [
            Checkbox(
              value: aceitoTermos,
              onChanged: (value) {
                setState(() {
                  aceitoTermos = value ?? false;
                });
              },
              activeColor: Colors.purple,
              // Adicionado para melhor contraste com o fundo gradiente
              checkColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Aceito os ',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'termos e condições',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showTermsAndConditionsModal(context);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          style: _botaoEstilo,
          onPressed:
              viewModel.registrarCommand.isRunning
                  ? null
                  : () {
                    if (!aceitoTermos) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Você deve aceitar os termos e condições para se cadastrar!",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (validator.validate(credentials).isValid &&
                        aceitoTermos) {
                      viewModel.registrarCommand.execute(credentials);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Por favor, corrija os erros no formulário.",
                          ),
                        ),
                      );
                    }
                  },
          icon: const Icon(Icons.person_add),
          label: const Text('Cadastrar'),
        ),
      ],
    );
  }

  Widget _buildSucessoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(
            "https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png",
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Verifique a sua caixa de e-mail para\nconfirmar o cadastro!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64),
        ElevatedButton.icon(
          onPressed: () => Routefly.navigate(routePaths.auth.login),
          icon: const Icon(Icons.login),
          label: const Text('Login'),
          style: _botaoEstilo,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  final _botaoEstilo = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );
}
