import 'package:auto_injector/auto_injector.dart';
import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/data/repositories/auth/remote_auth_repository.dart';
import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/data/repositories/carona/remote_carona_repository.dart';
import 'package:capy_car/data/repositories/rota/remote_rota_repository.dart';
import 'package:capy_car/data/repositories/rota/rota_repository.dart';
import 'package:capy_car/data/services/cloudinary/cloudinary_service.dart';
import 'package:capy_car/data/services/firebase/auth_service.dart';
import 'package:capy_car/data/services/firebase/store_service.dart';
import 'package:capy_car/main_viewmodel.dart';
import 'package:capy_car/ui/auth/login/login_viewmodel.dart';
import 'package:capy_car/ui/auth/logout/logout_viewmodel.dart';
import 'package:capy_car/ui/auth/registrar/registrar_viewmodel.dart';
import 'package:capy_car/ui/auth/senha/esqueci_senha_viewmodel.dart';
import 'package:capy_car/ui/carona/cadastro/cadastrar_carona_view_model.dart';
import 'package:capy_car/ui/carona/carona_home_viewmodel.dart';
import 'package:capy_car/ui/carona/visualizar/%5Bid%5D/carona_view_model.dart';
import 'package:capy_car/ui/components/appBottomNavigation_view_model.dart';
import 'package:capy_car/ui/components/appDrawer_view_model.dart';
import 'package:capy_car/ui/rota/rota_view_model.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_carro_viewmodel.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_foto_viewmodel.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_localizacao_viewmodel.dart';
import 'package:capy_car/ui/usuario/usuario_viewmodel.dart';

final injector = AutoInjector();

void setupDependecies() {

  //Services
  injector.addSingleton(CloudinaryService.new);
  injector.addSingleton(FirebaseAuthService.new);
  injector.addSingleton(FirestoreService.new);


  //Repositories
  injector.addSingleton<AuthRepository>(RemoteAuthRepository.new);
  injector.addSingleton<CaronaRepository>(RemoteCaronaRepository.new);
  injector.addSingleton<RotaRepository>(RemoteRotaRepository.new);

  //View Models
  injector.addSingleton<MainViewModel>(MainViewModel.new);
  injector.addSingleton<LoginViewModel>(LoginViewModel.new);
  injector.addSingleton<RegistrarViewModel>(RegistrarViewModel.new);
  injector.addSingleton<UsuarioViewModel>(UsuarioViewModel.new);
  injector.addSingleton<EsqueciSenhaViewModel>(EsqueciSenhaViewModel.new);
  injector.addSingleton<LogoutViewModel>(LogoutViewModel.new);
  injector.addSingleton<CadastrarLocalizacaoViewmodel>(CadastrarLocalizacaoViewmodel.new);
  injector.addSingleton<CadastarFotoViewModel>(CadastarFotoViewModel.new);
  injector.addSingleton<CadastrarCarroViewmodel>(CadastrarCarroViewmodel.new);
  injector.addSingleton<CaronaHomeViewModel>(CaronaHomeViewModel.new);
  injector.addSingleton<AppDrawerViewModel>(AppDrawerViewModel.new);
  injector.addSingleton<RotaViewModel>(RotaViewModel.new);
  injector.addSingleton<AppBottomNavigationViewModel>(AppBottomNavigationViewModel.new);
  injector.addSingleton<CadastrarCaronaViewModel>(CadastrarCaronaViewModel.new);
  injector.addSingleton<CaronaViewModel>(CaronaViewModel.new);




  injector.commit();
  //Outros

}