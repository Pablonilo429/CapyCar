# CapyCar 🚗

## 📝 Sobre o Projeto

O **CapyCar** é um aplicativo de caronas, com foco principal na plataforma **Web**, mas construído com Flutter para ser totalmente compatível com **Android** e **iOS**.

O objetivo do projeto é conectar a comunidade da **Universidade Federal Rural do Rio de Janeiro (UFRRJ)**, facilitando o transporte de estudantes e funcionários para promover a economia, a sustentabilidade e a integração no campus. A solução foi pensada como uma resposta prática aos desafios de mobilidade enfrentados pela comunidade acadêmica.

## ✨ Funcionalidades Principais

* **Oferecer Carona:** Motoristas podem publicar suas rotas, horários e número de vagas disponíveis.
* **Procurar Carona:** Passageiros podem buscar por caronas que se encaixem em seus destinos e horários.
* **Perfil de Usuário:** Sistema de perfis para garantir a segurança e a confiabilidade dos usuários.
* **Chat em Tempo Real:** Comunicação direta entre motoristas e passageiros dentro do app.
* **Upload de Imagens:** Utilização do Cloudinary para o armazenamento de fotos de perfil e do veículo.
* **Autenticação Segura:** Login e cadastro utilizando o Firebase Authentication.

## 🏛️ Arquitetura do Aplicativo

A estrutura deste projeto foi desenvolvida seguindo os conceitos e as boas práticas definidas na **App Architecture** pela [documentação oficial do Flutter](https://docs.flutter.dev/architecture). Isso garante um código mais limpo, escalável e de fácil manutenção.

## 🛠️ Tecnologias Utilizadas

Este projeto foi construído utilizando as seguintes tecnologias:

* **[Flutter](https://flutter.dev/)**: Framework de UI do Google para criar aplicações para web, mobile e desktop a partir de uma única base de código.
* **[Firebase](https://firebase.google.com/)**: Plataforma do Google utilizada para:
    * **Firebase Authentication**: Gerenciamento de usuários.
    * **Cloud Firestore**: Banco de dados NoSQL em tempo real.
* **[Cloudinary](https://cloudinary.com/)**: API para gerenciamento e armazenamento de imagens na nuvem.

## 🚀 Como Começar

Siga os passos abaixo para configurar e executar o projeto em seu ambiente local.

### Pré-requisitos

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (com suporte para web habilitado: `flutter channel stable; flutter upgrade; flutter config --enable-web`).
* Uma conta no [Firebase](https://firebase.google.com/).
* Uma conta no [Cloudinary](https://cloudinary.com/).

### Instalação e Configuração

1.  **Clone o repositório:**
    ```sh
    git clone [https://github.com/seu-usuario/capycar.git](https://github.com/seu-usuario/capycar.git)
    cd capycar
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Configure o Firebase:**
    * Acesse o [console do Firebase](https://console.firebase.google.com/) e crie um novo projeto.
    * Adicione os apps que deseja configurar (Web, Android, iOS).
    * **Para a Web:**
        * Registre seu app web e o Firebase fornecerá um objeto de configuração `firebaseConfig`.
        * Copie esse objeto e cole-o no `script` da tag `<head>` do seu arquivo `web/index.html`.
    * **Para Android (Opcional):**
        * Baixe o arquivo `google-services.json` e coloque-o na pasta `android/app/`.
    * **Para iOS (Opcional):**
        * Baixe o arquivo `GoogleService-Info.plist` e coloque-o na pasta `ios/Runner/` através do Xcode.
    * No console do Firebase, ative os serviços do **Authentication** e **Cloud Firestore**.

4.  **Configure o Cloudinary:**
    * Crie um arquivo `.env` na raiz do projeto (e adicione `.env` ao seu `.gitignore`).
    * Adicione suas credenciais do Cloudinary a este arquivo:
        ```
        CLOUDINARY_CLOUD_NAME=seu_cloud_name
        CLOUDINARY_API_KEY=sua_api_key
        CLOUDINARY_API_SECRET=seu_api_secret
        ```
    * **Nota:** Adapte a forma como você carrega essas variáveis de ambiente no seu código Dart (ex: usando o pacote `flutter_dotenv`).

### Executando o Aplicativo

Com tudo configurado, use os comandos abaixo para iniciar o aplicativo.

* **Para executar a versão Web (ex: no Chrome):**
    ```sh
    flutter run -d chrome
    ```

* **Para executar em um emulador ou dispositivo móvel conectado:**
    ```sh
    flutter run
    ```

## 📄 Licença e Uso

O código-fonte deste projeto é disponibilizado para fins educacionais e de portfólio.

**Importante:** Caso você deseje utilizar este código, ou partes dele, para **fins lucrativos ou não-lucrativos**, é **obrigatório** entrar em contato previamente através do e-mail:

**[pabloliv429@ufrrj.br](mailto:pabloliv429@ufrrj.br)**

A utilização sem a devida autorização está sujeita às medidas cabíveis.

## 🙏 Agradecimentos

* À comunidade da UFRRJ pela inspiração e motivação.
* Às equipes do Flutter, Firebase e Cloudinary pelas ferramentas incríveis.
* À toda equipe da Flutterando por disponibilizar materiais sobre App Architecture do Flutter e seus diversos packages.
