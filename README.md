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
  Na arquitetura de uma unidade de processamento central (CPU) é utilizado o ciclo Fetch-Decode-Execute (FDE) para executar instruções, nesse modelo o processador tem três estados, busca, decodificação e execução, dessa forma foi utilizado esse modelo no projeto com a adição do estado MEMORY para lidar com todas operações feitas com a memória. 

  O módulo responsavel nesse desenvolvimento é o `top.v` 
  
</div>

<div id="fetch">
  <h2>Estado de FETCH</h2>
  
  
</div>

<div id="decode">
  <h2>Estado de DECODE</h2>
  
  
</div>


<div id="execute">
  <h2>Estado de EXECUTE</h2>
  
  
</div>
  
<div id="memory">
  <h2>Estado de MEMORY</h2>
  
  
</div>

<div id="ula">
  <h2>Unidade Lógica e Aritmética (ULA)</h2>
  <p>
  O seu papel essencial é realizar diversas operações matemáticas e lógicas em dígitos binários, sendo os elementos básicos da informática. A ULA é crucial não só em cálculos simples, mas também nas decisões que acontecem dentro da unidade central de processamento. A ULA recebe do banco de registradores duas matrizes, opcode e um sinal de start, assim obviamente o opcode será qual operação será realizada. As instruções referente a operação são as seguintes: 
    <li>
      <code>0011</code> : Soma
    </li>
    <li>
      <code>0100</code> : Subtração
    </li>
    <li>
      <code>0101</code> : Multiplicação
    </li>
    <li>
      <code>0111</code> : Oposta
    </li>
    <li>
      <code>1000</code> : Multiplicação escalar
    </li>
    <li>
      <code>1001</code> : Determinante 2x2
    </li>
    <li>
      <code>1010</code> : Determinante 3x3
    </li>
    <li>
      <code>1011</code> : Determinante 4x4
    </li>
    <li>
      <code>1100</code> : Determinante 5x5 
    </li>
  </p>
   <p>
  Como é possível analisar é necessário para operação de determinante distinguir o tamanho da matriz, pois para as outras operações é trabalhado considerando que sempre irá obter o tamanho máximo, de maneira que se for enviado uma matriz de tamanho menor que o máximo estimulado o resultado ainda sairá correto, no caso da determinante o resultado sairá como errado nesse cenário. 
  </p>    
  
</div>

