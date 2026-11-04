# Especificação lexical e AFD de GreenScript

## Categorias lexicais

A especificação lexical de GreenScript contempla as palavras reservadas `LIGAR`, `DESLIGAR`, `ABRIR`, `FECHAR`, `AQUECER`, `PARAR`, `REGAR`, `ESPERAR`, `SE`, `SENAO`, `HUMIDADE` e `REPETIR`; identificadores de estufa; inteiros; os delimitadores `(`, `)`, `{`, `}`, `,` e `;`; e os operadores relacionais `<`, `<=`, `>`, `>=`, `==` e `!=`.

As palavras reservadas são representadas pelas alternativas literais e, por convenção, são reconhecidas apenas na grafia maiúscula apresentada:

```regex
^(LIGAR|DESLIGAR|ABRIR|FECHAR|AQUECER|PARAR|REGAR|ESPERAR|SE|SENAO|HUMIDADE|REPETIR)$
```

O identificador de estufa segue a expressão `^EST-[A-Z]{2}[0-9]{2}$`: ao prefixo `EST-` sucedem exatamente duas letras maiúsculas e dois algarismos. Os inteiros são definidos por `^(0|[1-9][0-9]*)$`, aceitando o zero isolado ou uma sequência iniciada por um algarismo de 1 a 9. Deste modo, inteiros com zeros à esquerda não pertencem à categoria.

Os delimitadores correspondem individualmente a `^[(){};,]$`. Os operadores relacionais são descritos por `^(<|<=|>|>=|==|!=)$`; os operadores compostos constituem lexemas de dois caracteres, enquanto `=` e `!` isolados não correspondem a nenhum operador enumerado.

Adota-se como convenção que as palavras reservadas são sensíveis a maiúsculas/minúsculas e que as mudanças de linha são LF ou CRLF, considerando CRLF uma unidade `EOL`. Com `C` como alfabeto de caracteres, o comentário é descrito abstratamente por `^#(C \ {EOL})*$`: começa por `#` e prolonga-se até imediatamente antes de `EOL` ou até ao fim da entrada. A notação `C \ {EOL}` representa uma classe por complemento, não a sintaxe de uma ferramenta específica de regex. A sequência de espaços ignorados é `^(SP|TAB|EOL)+$`, em que `SP`, `TAB` e `EOL` representam, respetivamente, um espaço, uma tabulação e uma mudança de linha. Estas convenções tornam explícitas decisões que o enunciado não fixa e devem ser confirmadas pelo grupo.

## AFD do identificador de estufa

O formato do identificador é `EST-` seguido de duas letras maiúsculas e dois algarismos. O AFD inicia em `q0`; cada estado seguinte representa a leitura do prefixo válido até esse ponto. O único percurso de aceitação é:

```text
--> (q0) --E--> (q1) --S--> (q2) --T--> (q3) --[-]--> (q4) --[A-Z]--> (q5) --[A-Z]--> (q6) --[0-9]--> (q7) --[0-9]--> ((q8))
```

`q8` é o único estado final. De qualquer estado, um símbolo diferente do esperado conduz ao estado de erro `q⊥`, que permanece nesse estado para qualquer símbolo adicional. A leitura de qualquer símbolo depois de `q8` também conduz a `q⊥`. Assim, o autómato aceita uma cadeia apenas se toda a entrada tiver sido consumida e o estado final for `q8`. Por exemplo, `EST-AB12` é aceite. Cadeias incompletas, com letras minúsculas, algarismos nas posições das letras ou caracteres adicionais, como `EST-AB1`, `EST-ab12`, `EST-A912` e `EST-AB123`, são rejeitadas.

## Limites da análise

O analisador lexical identifica categorias de lexemas, mas não determina se a sequência de tokens respeita a sintaxe dos comandos GreenScript nem executa instruções. O operador «maior ou igual» é escrito `>=`, considerando-se o espaço em `> =` um lapso tipográfico, dado que a lista também enumera explicitamente `>=`. A especificação completa, com exemplos, convenções e tabela de transições do AFD, encontra-se no [documento de especificação](./especificacao-elemento1.md).
