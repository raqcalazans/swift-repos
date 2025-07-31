# Swift Repos 

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVI%2BCoordinator-blue)
![License](https://img.shields.io/badge/license-MIT-green.svg)

Um aplicativo iOS nativo que consome a API do GitHub para listar os repositórios mais populares da linguagem Swift e visualizar seus Pull Requests. Este projeto foi desenvolvido como um desafio técnico, focando em boas práticas de arquitetura de software e desenvolvimento iOS moderno.

---

## Funcionalidades

-   **Lista de Repositórios**: Exibe uma lista dos repositórios Swift com mais estrelas no GitHub.
-   **Paginação**: A lista de repositórios é paginada para uma experiência de usuário fluida e eficiente.
-   **Lista de Pull Requests**: Ao selecionar um repositório, o app exibe uma lista com todos os seus Pull Requests (abertos e fechados).
-   **Visualização de PR**: Ao tocar em um Pull Request, uma webview é aberta modalmente para exibir a página oficial do PR no GitHub.

---

## Arquitetura

Este projeto foi construído utilizando uma arquitetura moderna e escalável, combinando os padrões **MVI (Model-View-Intent)** e **Coordinator**.

-   **MVI (Model-View-Intent)**: Garante um fluxo de dados unidirecional e um estado previsível para cada tela.
    -   **Model/State**: Uma única fonte da verdade que representa todo o estado da UI.
    -   **View**: Camada passiva que apenas renderiza o estado e encaminha as interações do usuário.
    -   **Intent**: Representa as intenções do usuário, que são processadas pelo ViewModel.
    -   **ViewModel**: Orquestra a lógica da feature, processa os `Intents` e emite novos `States`.

-   **Coordinator**: Gerencia todo o fluxo de navegação do aplicativo, desacoplando completamente as `Views` da responsabilidade de navegar entre telas.

-   **Injeção de Dependência (DI)**: Utilizamos protocolos para injetar dependências (como o `APIService`) nos `ViewModels`, facilitando a testabilidade e a manutenção do código.

-   **Programação Reativa**: A comunicação entre as camadas da arquitetura é feita utilizando **RxSwift**, garantindo um código mais declarativo e responsivo.

---

## Como Executar

**Pré-requisitos:**
* macOS
* Xcode 16 ou superior
* Swift 5

**Passos:**

1.  Clone o repositório:
    ```bash
    git clone [https://github.com/raqcalazans/swift-repos.git](https://github.com/raqcalazans/swift-repos.git)
    ```
2.  Abra o arquivo `SwiftRepos.xcodeproj` no Xcode.
3.  O Xcode irá resolver as dependências (RxSwift) automaticamente via Swift Package Manager.
4.  Compile e execute o projeto em um simulador ou dispositivo físico (`Cmd + R`).

---

## Screenshots

| Lista de Repositórios                               | Lista de Pull Requests                               |
| --------------------------------------------------- | ---------------------------------------------------- |
| ![Imagem da Lista de Repositórios] | ![Imagem da Lista de Pull Requests] |

