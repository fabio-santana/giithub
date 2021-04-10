Feature: Acesso Api do GitHub
Como um cliente
Quero pesquisar por usuarios no GitHub
Para que eu possa ver os dados de forma simplificada e detalhada e também favoritar

Cenário: Pesquisar pelo id do usuário válido
Dado que o cliente informou um id válido
Quando solicitar a pesquisa à Api
Então o sistema deve enviar o cliente para a tela de dados do usuário pesquisado
E permitir que o cliente visualise os dados de forma simplificada ou detalhada
E permitir que o cliente favorite o(s) usuário(s) pesquisado(s).

Cenário: Pesquisar pelo id em branco
Dado que o cliente não informou um id
Quando solicitar a pesquisa à Api
Então o sistema deve enviar o cliente para a tela de dados do usuário, mostrando a lista de usuários que aparece da url 'https://api.github.com/users'
E permitir que o cliente favorite o(s) usuário(s) pesquisado(s).

Cenário: Pesquisar pelo id do usuário inválido
Dado que o cliente informou um id inválido
Quando solicitar a pesquisa à Api
Então o sistema deve enviar uma mensagem informando que o usuário não foi localizado
E permitir que o cliente faça uma nova pesquisa.