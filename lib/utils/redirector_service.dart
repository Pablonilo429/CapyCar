import 'package:capy_car/main.dart';
import 'package:capy_car/main_viewmodel.dart';
import 'package:routefly/routefly.dart';

class RedirectorService {
  final MainViewModel _mainViewModel;

  RedirectorService(this._mainViewModel) {
    _mainViewModel.addListener(_handleUsuarioChange);
  }

  void _handleUsuarioChange() {
    final usuario = _mainViewModel.usuario;

    if (usuario == null) return;

    if (usuario.isPrimeiroLogin == true) {
      if (usuario.campus == null || usuario.campus!.isEmpty) {
        Routefly.navigate(routePaths.usuario.cadastro.cadastrarLocalizacao);
      } else {
        Routefly.navigate(routePaths.usuario.cadastro.cadastrarPapel);
      }
    } else {
      Routefly.navigate(routePaths.carona.caronaHome);
    }
  }

  void dispose() {
    _mainViewModel.removeListener(_handleUsuarioChange);
  }
}
