# HTTP

> ## Sucesso

1. Request com verbo http válido (post) - OK
2. Passar nos headers o content type JSON - OK
3. Chamar request com o body correto - OK
4. OK - 200 e resposta com dados - OK
5. No content - 204 e resposta sem dados - OK

> ## Erros

1. Bad Request - 400 - OK
2. Unauthorized - 401 - OK
3. Forbidden - 403 - OK
4. Not Found - 404 - OK
5. Internal Server Error - 500 - OK

> ## Exceção - Status code diferente dos citados acima

1. Internal Server Error - 500 - OK

> ## Exceção - Http request deu alguma exceção

1. Internal Server Error - 500 - OK

> ## Exceção - Verbo http inválido

1. Internal Server Error - 500 - OK
