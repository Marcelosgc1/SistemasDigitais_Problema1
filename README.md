<h1 align="center">Coprocessador aritmético especializado em operações matriciais</h1>

<h2>Descrição do Projeto</h2>
<p>
  Para elaboração do projeto foi utilizado o kit de desenvolvimento De1-SoC de processador Cyclone V para a leitura e escrita dos procedimentos na memória RAM desse kit. O programa consiste em criar um coprocessador para lidar com matrizes quadradas de tamanho 2x2 até 5x5, a fim de reduzir a tensão sobre o processador principal para o aumento de desempenho. As operações com matrizes são algo primordial para o universo computacional, pois elas lidam com diversos tipos de paradigmas como processamento de imagens, criptografias, telecomunicações, etc. Desse modo, é possível utilizar esse repositório para esses fins de desenvolvimento.  

  O coprocessador é capaz de lidar com as seguintes operações:

  * Soma
  * Subtração
  * Multiplição
  * Multiplicação escalar
  * Determinante
  * Transposição de matriz
  * Matriz oposta

</p>

Sumário
=================
<!--ts-->
   * [Caminho de Dados](#caminho-de-dados)
   * [Arquitetura da Instrução](#instrucao)
   * [Máquina de Estados](#maquina-de-estados)
      * [FETCH](#fetch)
      * [DECODE](#decode)
      * [EXECUTE](#execute)
      * [MEMORY](#memory)
   * [Unidade Lógica e Aritmética (ULA)](#ula)
   * [Testes](#testes) 
   * [Resultados](#resultados)
   * [Referências](#referencias)
<!--te-->
<div id="caminho-de-dados">
  <h2>Caminho de Dados</h2>
  <p>
    O caminho de dados é uma unidade funcional dentro de um processador que executa operações de processamento de dados usando componentes como unidades lógicas aritméticas, barramentos, multiplexadores e     registradores. É responsável por executar instruções e manipular dados no processador.

    
  </p>


  
</div>

<div id="instrucao">
  <h2>Arquitetura da Instrução</h2>


  
</div>

<div id="maquina-de-estados">
  <h2>Máquina de Estados</h2>
  Na arquitetura de uma unidade de processamento central (CPU) é utilizado o ciclo Fetch-Decode-Execute (FDE) para executar instruções, nesse modelo o processador tem três estados busca, decodificação e execução, dessa forma foi utilizado esse modelo com a criação do estado de memória para lidar com todo esse paradigma.


  O módulo responsavel nesse desenvolvimento é o `top.v` 
  
</div>


  
