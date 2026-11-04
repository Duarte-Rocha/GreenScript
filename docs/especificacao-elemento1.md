# GreenScript — Especificação lexical (Elemento 1)

## 1. Introdução à especificação lexical

Este documento formaliza as categorias lexicais indicadas para GreenScript e o AFD do identificador de estufa. A análise lexical reconhece lexemas; não verifica se estes formam comandos sintaticamente válidos nem executa instruções.

As regex abaixo descrevem lexemas completos. `^` e `$` indicam, respetivamente, o início e o fim do lexema considerado. Usa-se `[A-Z]` para as letras maiúsculas ASCII e `[0-9]` para os algarismos decimais. Para tornar a notação inequívoca, adotam-se neste documento estas convenções explícitas, a confirmar pelo grupo: as palavras reservadas só são reconhecidas na grafia maiúscula apresentada; `>=` é o operador «maior ou igual» (o espaço em `> =` é tratado como lapso tipográfico); e as mudanças de linha são LF ou CRLF, contando CRLF como uma unidade `EOL`. Não se especifica como sequências de lexemas adjacentes são divididas em tokens, pois essa política não consta das tarefas do Elemento 1.

## 2. Expressões regulares das categorias lexicais

### Palavras reservadas

```regex
^(LIGAR|DESLIGAR|ABRIR|FECHAR|AQUECER|PARAR|REGAR|ESPERAR|SE|SENAO|HUMIDADE|REPETIR)$
```

Cada alternativa corresponde literalmente a uma das palavras indicadas. Pela convenção adotada, só a grafia em maiúsculas indicada é válida.

Exemplos: `LIGAR`, `SENAO` e `HUMIDADE` correspondem à expressão. `LIGA`, `LIGARX` e `ligar` não correspondem como lexemas completos; no último caso, a rejeição resulta da convenção de grafia exata em maiúsculas adotada neste documento.

### Identificadores de estufa

```regex
^EST-[A-Z]{2}[0-9]{2}$
```

`EST-` é o prefixo literal; `[A-Z]{2}` exige exatamente duas letras maiúsculas; `[0-9]{2}` exige exatamente dois algarismos. Não são aceites caracteres adicionais no lexema.

Exemplos válidos: `EST-AB12`, `EST-ZZ00`. Exemplos inválidos: `EST-A12` (falta uma letra), `EST-ABC12` (uma letra a mais), `EST-AB1` (falta um algarismo), `EST-AB123` (um algarismo a mais), `EST-ab12` (letras minúsculas onde se exigem maiúsculas) e `EST-1B12` (algarismo numa posição reservada a letra).

### Inteiros

```regex
^(0|[1-9][0-9]*)$
```

A alternativa `0` admite o zero isolado. `[1-9]` exige que um inteiro não nulo comece por algarismo de 1 a 9; `[0-9]*` permite zero ou mais algarismos seguintes. Não há sinal na expressão.

Exemplos válidos: `0`, `7`, `204`. Exemplos inválidos: `00` e `08` (zeros à esquerda), `-3` (sinal não incluído) e a cadeia vazia (não contém algarismos).

### Delimitadores

```regex
^[(){};,]$
```

A classe de caracteres representa exatamente um dos delimitadores: parêntese esquerdo ou direito, chaveta esquerda ou direita, vírgula ou ponto e vírgula. Cada delimitador é um lexema individual.

Exemplos válidos: `(`, `)`, `{`, `}`, `,`, `;`. `[]` não corresponde: os parênteses retos não constam da lista. `()` não é um único delimitador; é uma sequência de dois caracteres que correspondem individualmente a delimitadores.

### Operadores relacionais

```regex
^(<|<=|>|>=|==|!=)$
```

As alternativas correspondem aos seis operadores enumerados: menor, menor ou igual, maior, maior ou igual, igual e diferente. Os operadores de dois caracteres têm de ser considerados como lexemas completos para não os confundir com os respetivos prefixos de um caractere.

Exemplos válidos: `<`, `<=`, `>`, `>=`, `==`, `!=`. `=` e `!` isolados não correspondem a nenhuma alternativa. `===` também não corresponde a um operador enumerado como lexema completo.

### Comentários

Considerando `EOL` uma unidade de mudança de linha (LF ou CRLF) e `C` o alfabeto de caracteres, a expressão abstrata do comentário é:

```text
^#(C \ {EOL})*$
```

Aqui, `C \ {EOL}` representa qualquer carácter do conteúdo que não seja a unidade `EOL`; é uma notação formal por complemento, não a sintaxe de uma ferramenta específica de regex. O primeiro `#` inicia o comentário; seguem-se zero ou mais desses caracteres. O terminador não faz parte do comentário.

Exemplos: `#`, `# nota` e `# LIGAR(EST-AB12)` são comentários desde que não incluam um terminador de linha. Numa linha `# nota`, o conteúdo após `#` não é analisado como palavras ou delimitadores. Uma quebra de linha não pertence ao lexema do comentário.

### Espaços em branco

Definam-se `SP` como um espaço, `TAB` como uma tabulação e `EOL` como uma mudança de linha (LF ou CRLF, sendo CRLF uma unidade). A categoria ignorada é descrita por:

```text
^(SP|TAB|EOL)+$
```

Cada alternativa representa uma unidade de espaço em branco indicada no enunciado; `+` representa uma ou mais dessas unidades. Estas sequências são ignoradas e não originam tokens. A escolha de LF/CRLF como representação concreta de `EOL` é uma convenção deste documento, não uma indicação explícita do enunciado.

Exemplos: um espaço, uma tabulação, uma mudança de linha e sequências como espaço-tabulação-mudança de linha são ignoradas. Outros caracteres de controlo, como form feed, não podem ser classificados com base no enunciado.

## 3. Exemplos de cadeias válidas e inválidas

Esta tabela resume exemplos por categoria. «Inválido» significa que o lexema completo não pertence à categoria indicada; não determina, por si só, como uma sequência maior deve ser dividida em tokens.

| Categoria | Válidos | Não correspondem à categoria |
|---|---|---|
| Palavras reservadas | `LIGAR`, `FECHAR`, `REPETIR` | `LIGA`, `LIGARX`, `ligar` (inválidos segundo a convenção de grafia exata em maiúsculas) |
| Identificador de estufa | `EST-AB12`, `EST-ZZ00` | `EST-A12`, `EST-ABC12`, `EST-AB123`, `EST-ab12`, `EST-1B12` |
| Inteiro | `0`, `1`, `204` | `00`, `08`, `-3`, cadeia vazia |
| Delimitador | `(`, `)`, `{`, `}`, `,`, `;` | `[`, `]`, `()` como lexema único |
| Operador relacional | `<`, `<=`, `>`, `>=`, `==`, `!=` | `=`, `!`, `===` |
| Comentário | `#`, `# observação` até ao EOL/fim da entrada | `observação` sem `#`; uma quebra de linha incluída no lexema do comentário |
| Espaço em branco | espaço, tabulação, mudança de linha | form feed, cuja classificação não está definida |

## 4. Autómato Finito Determinístico (AFD) dos identificadores de estufa

### Alfabeto

Para o AFD, considera-se como alfabeto de entrada `Σ` o conjunto de caracteres ASCII. Esta é uma escolha de formalização para o autómato; o enunciado não define a codificação global do ficheiro. Particiona-se `Σ` nas classes `E`, `S`, `T`, `H` (hífen), `M` (letras maiúsculas ASCII diferentes de `E`, `S` e `T`), `D` (algarismos `[0-9]`) e `O` (todos os restantes caracteres ASCII). As classes são disjuntas. A classe `O` inclui letras minúsculas e quaisquer outros caracteres ASCII.

### Estados

```text
Q = {q0, q1, q2, q3, q4, q5, q6, q7, q8, q⊥}
Estado inicial: q0
Estados finais: F = {q8}
```

`q0` é o estado inicial. `q1` a `q7` representam os prefixos válidos incompletos; `q8` representa a cadeia exata completa; `q⊥` é o estado de erro, não final.

### Transições

As únicas transições que não conduzem ao estado de erro são as da tabela:

| Estado | `E` | `S` | `T` | `H` (`-`) | `M` (outra maiúscula) | `D` (algarismo) | `O` |
|---|---|---|---|---|---|---|---|
| `q0` | `q1` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` |
| `q1` | `q⊥` | `q2` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` |
| `q2` | `q⊥` | `q⊥` | `q3` | `q⊥` | `q⊥` | `q⊥` | `q⊥` |
| `q3` | `q⊥` | `q⊥` | `q⊥` | `q4` | `q⊥` | `q⊥` | `q⊥` |
| `q4` | `q5` | `q5` | `q5` | `q⊥` | `q5` | `q⊥` | `q⊥` |
| `q5` | `q6` | `q6` | `q6` | `q⊥` | `q6` | `q⊥` | `q⊥` |
| `q6` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q7` | `q⊥` |
| `q7` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q8` | `q⊥` |
| `q8` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` |
| `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` | `q⊥` |

Formalmente, `δ: Q × Σ → Q` é dada pelas transições da tabela. Para toda a classe não indicada em cada prefixo, `δ` conduz a `q⊥`; de `q⊥`, qualquer símbolo mantém o autómato em `q⊥`. Assim, a função é total sobre `Σ`.

### Diagrama

```text
--> (q0) --E--> (q1) --S--> (q2) --T--> (q3) --H--> (q4) --[A-Z]--> (q5) --[A-Z]--> (q6) --D--> (q7) --D--> ((q8))
                                                                                                         |
                                                                                                         | qualquer símbolo
                                                                                                         v
                                                                                                       (q⊥)
```

Para manter o diagrama legível, as transições inválidas de qualquer estado e o ciclo de `q⊥` são indicados pela regra completa seguinte: qualquer símbolo que não seja o esperado na tabela conduz a `q⊥`; qualquer símbolo lido em `q8` também conduz a `q⊥`; `q⊥` transita para si próprio com qualquer símbolo. `((q8))` assinala o único estado final.

### Funcionamento, aceitação e rejeição

O autómato consome a entrada da esquerda para a direita: `E`, `S`, `T`, hífen, duas letras maiúsculas e dois algarismos. Só aceita se a entrada terminar em `q8`, isto é, após consumir exatamente `EST-` + duas maiúsculas + dois algarismos. Uma entrada incompleta termina em `q0`–`q7` e é rejeitada. Uma letra minúscula, um símbolo inesperado ou qualquer carácter adicional conduz a `q⊥`, pelo que a cadeia é rejeitada.

Aceites: `EST-AB12`, `EST-ZZ00`. Rejeitadas: `EST-AB1` (incompleta), `EST-ab12` (minúsculas), `EST-AB123` (carácter adicional), `EST-A912` (algarismo na posição de letra) e `EST-AB1X` (carácter incorreto na posição final). A cadeia vazia também é rejeitada, pois o estado inicial não é final.

## 5. Texto académico pronto a integrar no relatório

### Especificação lexical

A especificação lexical de GreenScript inclui as palavras reservadas `LIGAR`, `DESLIGAR`, `ABRIR`, `FECHAR`, `AQUECER`, `PARAR`, `REGAR`, `ESPERAR`, `SE`, `SENAO`, `HUMIDADE` e `REPETIR`; identificadores de estufa no formato `EST-` seguido de duas letras maiúsculas e dois algarismos; inteiros definidos por `0` ou por uma sequência iniciada entre `1` e `9`; os delimitadores `(`, `)`, `{`, `}`, `,` e `;`; e os operadores relacionais `<`, `<=`, `>`, `>=`, `==` e `!=`. As palavras reservadas são representadas por alternativas literais, o identificador por `EST-[A-Z]{2}[0-9]{2}` e o inteiro por `0|[1-9][0-9]*`, com correspondência do lexema completo. Esta definição exclui inteiros com zeros à esquerda e identificadores com letras minúsculas, comprimento incorreto ou caracteres adicionais.

Os comentários iniciam-se em `#` e estendem-se até ao terminador de linha, que não pertence ao comentário. Espaços, tabulações e mudanças de linha são ignorados. Nesta formalização, LF e CRLF são terminadores de linha (CRLF conta como uma unidade) e as palavras reservadas são sensíveis a maiúsculas/minúsculas, aceitando apenas a grafia indicada. Estas são convenções explícitas para os aspetos que o enunciado não determina.

### AFD do identificador de estufa

O identificador de estufa é reconhecido por um AFD cujos estados representam os prefixos sucessivos de `EST-` + duas letras maiúsculas + dois algarismos. O estado inicial `q0` não é final; o único estado final é `q8`, alcançado após a leitura dos oito caracteres exigidos. Qualquer símbolo inesperado, incluindo um carácter adicional após o identificador completo, conduz ao estado de erro não final `q⊥`, que possui um ciclo para todos os símbolos. Assim, o autómato aceita, por exemplo, `EST-AB12` e rejeita identificadores incompletos, com minúsculas, posições incorretas ou sufixos adicionais. A aceitação exige que toda a entrada termine em `q8`.

## 6. Verificação de consistência da especificação

- **Categorias:** estão contempladas todas as categorias enumeradas: palavras reservadas, identificador de estufa, inteiros, delimitadores, operadores relacionais, comentários e espaços em branco.
- **Correspondência regex–regras:** as regex do identificador e do inteiro refletem diretamente os formatos definidos; as classes de delimitadores e operadores enumeram os símbolos indicados; comentários e espaços em branco usam as convenções LF/CRLF declaradas acima.
- **AFD:** o único percurso não erróneo consome `E S T - [A-Z] [A-Z] [0-9] [0-9]`, correspondendo exatamente a `EST-` + duas maiúsculas + dois algarismos. Só `q8` é final, e qualquer símbolo adicional ou inesperado conduz ao estado de erro.
- **Convenções e âmbito a confirmar:** (1) `> =` foi interpretado como `>=`, pois o enunciado também enumera explicitamente o operador maior ou igual; (2) as palavras reservadas foram tratadas como sensíveis a maiúsculas/minúsculas; (3) LF e CRLF foram adotados como mudanças de linha, contando CRLF como uma unidade; (4) o AFD usa o alfabeto ASCII para definir transições também para símbolos inválidos. Estas escolhas tornam a especificação inequívoca, mas devem ser confirmadas pelo grupo. A divisão de lexemas adjacentes em tokens fica fora do âmbito desta especificação teórica.

O analisador lexical limita-se à identificação das categorias e não determina se uma sequência de tokens respeita a sintaxe dos comandos GreenScript.
