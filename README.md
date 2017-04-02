# Desafio Spotippos

Este é o desafio Spotippos, o code-challenge do VivaReal.

## Instalação e Uso

Você precisa ter a linguagem [Crystal](https://crystal-lang.org) versão 0.21.1
instalada para poder rodar ou compilar o projeto. Você também pode usar o
Dockerfile incluso para [rodar direto no Docker](#para-rodar-no-docker).

Você pode usar o atalho do Crystal para compilar e rodar direto:

```bash
crystal ./src/spotippos.cr
```

Ou pode compilá-lo e rodar a versão compilada:

```bash
crystal build --release ./src/spotippos.cr
./spotippos
```

O webserver estará disponível na porta 3000.

Ao fazer as chamadas para o webserver, é importante definir o cabeçalho
`Content-type: application/json`.

### Para rodar os testes

```crystal
KEMAL_ENV=test crystal spec
```

**IMPORTANTE**: Se você esquecer o `KEMAL_ENV=test`, o Kemal vai subir o servidor
e travar os testes para sempre :(

## Para rodar no Docker

Construa a imagem:
```bash
docker build -t spotippos .
```

Crie um container através dela, expondo a porta que você quiser para acessá-lo:
```bash
docker run -p 3000:3000 spotippos
```

Para rodar os testes no Docker, faça:
```bash
docker run -e KEMAL_ENV=test spotippos crystal spec
```

## Racionais do projeto

### Linguagem e Framework

Usei a linguagem [Crystal](https://crystal-lang.org), que é uma linguagem
fortemente inspirada em Ruby, porém estaticamente tipada e compilada através
do LLVM, o que garante ela rodar rapidamente, com uma boa performance e
prevenindo erros de tipagem em tempo de compilação. Ela ainda está em beta, na
versão 0.21.1, e por enquanto só roda em Linux e OS X. A vantagem dela é que é
tão parecida com Ruby que qualquer Rubista, com pouquíssimo tempo de
aprendizagem, consegue ler e escrever código Crystal, que tem uma boa
performance, por ser compilada.

A camada de roteamento é feita usando [Kemal](http://kemalcr.com/), um framework
inspirado no Sinatra.

Para os testes, usei [Spec2](https://github.com/waterlink/spec2.cr), inspirado
no RSpec.

O motivo de eu ter usado essa linguagem é que eu queria escrever alguma coisa
nela e, bem, o teste veio a calhar :P Acho que não rolaria usar em produção pois
o ecossistema ainda é bastante jovem, a documentação é pouca e as mensagens de
erro ainda estão muito crípticas.

### Camada de acesso a dados

No repositório da aplicação estou acessando uma variável de classe (`@@storage`)
que representa a persistência dos dados. Tentei representar um storage externo,
e a ideia é que caso fosse usado num cenário real, ele fosse facilmente
substituível.

Ao iniciar o projeto, uso o método `Fixtures.load_fixtures` para carregar os
dados providos. Não criei opções para passar arquivos de input diferentes, mas
é uma modificação trivial se precisar ser feito.

### Tratamento da resposta dos JSONs

Um próximo passo seria paginar a resposta da rota `GET /properties`, por
exemplo, já que ela pode retornar milhares de imóveis.

### Sobre os tipos de variáveis

Por simplicidade, estou assumindo que todos os dados numéricos do imóvel são
inteiros, apesar de alguns conceitualmente poderem ser decimais "no mundo real".

Uma coisa que ficou um pouco esquisita é que várias conversões de Integer32 para
Integer64 ficaram espalhadas pelo código. Isso aconteceu pois a lib que eu usei
para atender as requisições web e os JSONs trabalha com Int64 e o
core da linguagem com Int32. Não corri muito atrás de "resolver" isso pela
questão do tempo, então o código ficou mais feio do que poderia.

### Testes

Não escrevi specs para as Entities, pois são "POCOs" (Plain Old Crystal
Objects), nem para os Containers, pois apenas facilitam o uso das bibliotecas
em desenvolvimento.

Escrevi os testes pros Controllers acessando direto o endpoint, como um teste
de integração, para não ter que simular o `env` (contexto HTTP) do Kemal.

Não usei nenhuma lib para fazer factories ou fixtures pois todas que testei
estavam bem bugadas :P Por conta disso, faço a inicialização do ambiente de
teste de forma verbosa, criando todos os objetos e inserindo-os no storage.

## Autor

[Bruno Assis](https://github.com/[BrunoAssis])
