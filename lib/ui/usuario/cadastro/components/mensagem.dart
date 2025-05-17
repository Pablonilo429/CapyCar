import 'package:capy_car/utils/LoaderWidget.dart';
import 'package:flutter/material.dart';

class MensagemComponent extends StatefulWidget {
  final VoidCallback onFinished;

  const MensagemComponent({super.key, required this.onFinished});

  @override
  State<MensagemComponent> createState() => _MensagemComponentState();
}

class _MensagemComponentState extends State<MensagemComponent> {
  int _stage = 0;

  @override
  void initState() {
    super.initState();
    _iniciarAnimacao();
  }

  void _iniciarAnimacao() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _stage = 1);

    await Future.delayed(const Duration(seconds: 2));
    setState(() => _stage = 2);

    await Future.delayed(const Duration(seconds: 2));
    setState(() => _stage = 3);

    await Future.delayed(const Duration(seconds: 3));
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: _buildConteudoAtual(),
    );
  }

  Widget _buildConteudoAtual() {
    switch (_stage) {
      case 0:
        return _MensagemWidget(texto: 'Cadastro feito com sucesso!');
      case 1:
        return _MensagemWidget(texto: 'Mantenha sempre um ambiente\neducado e saudável :)');
      case 2:
        return _MascoteWidget();
      case 3:
        return LoaderWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _MensagemWidget extends StatelessWidget {
  final String texto;

  const _MensagemWidget({required this.texto});

  @override
  Widget build(BuildContext context) {
    return BackgroundPadrao(
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MascoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundPadrao(
      child: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: const NetworkImage("https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png"),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}




