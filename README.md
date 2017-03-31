# Desafio Spotippos

Este é o desafio Spotippos, o code-challenge do VivaReal.

## Instalação

## Uso

## Racionais do projeto

### Linguagem e Framework

Usei a linguagem [Crystal](https://crystal-lang.org), que é uma linguagem
fortemente inspirada em Ruby, porém estaticamente tipada e compilada através
do LLVM, o que garante ela rodar rapidamente, com uma boa performance e
prevenindo erros de tipagem em tempo de compilação. Ela ainda está em beta, na
versão 0.21.1, e por enquanto só roda em Linux e OS X. A vantagem dela é que é
tão parecida com Ruby que qualquer Rubista, com pouquíssimo tempo de
aprendizagem consegue ler e escrever código nela.

A camada de roteamento é feita usando [Kemal](http://kemalcr.com/), um framework
inspirado no Sinatra.

Para os testes, usei [Spec2](https://github.com/waterlink/spec2.cr), inspirado
no RSpec.

O motivo de eu ter usado essa linguagem é que eu queria escrever alguma coisa
nela e, bem, o teste veio a calhar :P Acho que não rolaria usar em produção pois
o ecossistema ainda é bastante jovem.

### Camada de acesso a dados

No repositório da aplicação estou acessando uma variável de classe (`@@storage`)
que representa a persistência dos dados.

### Sobre os tipos de variáveis

Por simplicidade, estou assumindo que todos os dados numéricos do imóvel são
inteiros, apesar de alguns conceitualmente poderem ser decimais "no mundo real".

### Mudança no payload de cadastro

O arquivo `properties.json` fornecido não contém as propriedades "x" e "y",
conforme as [instruções](https://github.com/VivaReal/code-challenge/blob/master/backend.md).
Em vez disso, ele contém as propriedades "lat" e "long". Como acredito que esses
nomes são semanticamente mais relevantes do que "x" e "y", tomei a liberdade de
alterar o nome destas propriedades no payload de cadastro.

Acredito que essa diferença não faça parte do desafio e tenha sido uma questão
que passou despercebida na elaboração dele, então, abri um pull request
corrigindo essa informação e o payload de cadastro nas instruções do desafio.

## Autor

[Bruno Assis](https://github.com/[BrunoAssis])
