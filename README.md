# README — Projeto GreenScript (TP1 Compiladores)

## Descrição

Analisador léxico da linguagem **GreenScript**, implementado em **FLEX**, no âmbito do Trabalho Prático 1 da unidade curricular de Compiladores (UTAD | LEI).

O lexer identifica tokens e erros lexicais, mas **não valida sintaxe** nem executa comandos.

## Estrutura do projeto

```
TP1_num1_num2_num3/
├── src/            # código-fonte FLEX e módulos auxiliares
├── testes/         # ficheiros de entrada e resultados esperados
├── README.md       # este ficheiro
└── relatorio.pdf   # relatório (máx. 4 páginas)
```

## Ferramentas utilizadas

- **FLEX** (versão: _preencher_)
- **GCC** (versão: _preencher_)
- **Make** (opcional)

## Compilação e execução

```bash
# Compilar
flex -o src/lexer.c src/lexer.l
gcc -o greenscript src/lexer.c

# Executar (caminho do ficheiro como argumento)
./greenscript testes/teste_valido_01.gs
```

Saída esperada por token: `linha CATEGORIA lexema`, e no final:
```
Tokens: N | Erros lexicais: M
```

---

## Divisão de tarefas por elemento

### Elemento 1 — Especificação teórica (regex + AFD)

**Responsabilidades:**
- Definir as **expressões regulares** de todas as categorias lexicais:
  - palavras reservadas (`LIGAR`, `DESLIGAR`, `ABRIR`, `FECHAR`, `AQUECER`, `PARAR`, `REGAR`, `ESPERAR`, `SE`, `SENAO`, `HUMIDADE`, `REPETIR`);
  - identificador de estufa (`EST-` + 2 maiúsculas + 2 algarismos);
  - inteiro (`0` ou sequência iniciada por `1–9`);
  - delimitadores (`( ) { } , ;`);
  - operadores relacionais (`<`, `<=`, `>`, `>=`, `==`, `!=`);
  - comentários (`#` até fim de linha);
  - espaços/tabs/newlines ignorados.
- Apresentar **exemplos válidos e inválidos** para cada categoria.
- Construir o **AFD dos identificadores de estufa**: alfabeto, estado inicial, estados finais, transições e rejeição.
- Redigir as secções teóricas do **relatório** (regex + autómato).

**Entregáveis:** documento de especificação + texto do relatório.

---

### Elemento 2 — Implementação em FLEX (núcleo do lexer)

**Responsabilidades:**
- Escrever o ficheiro **`src/lexer.l`** com todas as regras FLEX.
- Implementar a **regra do candidato lexical máximo**: sequência de letras/algarismos/hífen/underscore tratada como um único candidato; se não for válida → **um único erro**.
- Implementar o **reconhecimento mais longo** dos operadores (`<=`, `>=`, `==`, `!=`).
- Ler o **ficheiro de entrada a partir do argumento** da linha de comandos.
- Emitir tokens com **categoria, lexema e linha de início**; contar corretamente **LF e CRLF** como uma só linha.
- Implementar **diagnósticos de erro** (lexema + linha) e **continuação** após erros.
- Apresentar no final os **totais de tokens e erros lexicais**.
- Escrever o **README** (compilação/execução) e o `Makefile` (se aplicável).

**Entregáveis:** `src/` funcional + README.

---

### Elemento 3 — Testes, integração e relatório final

**Responsabilidades:**
- Criar os **8 ficheiros de teste** obrigatórios em `testes/`:
  1. comandos simples (válido);
  2. espera (válido);
  3. condição com `SENAO` e todos os operadores relacionais (válido);
  4. tokens válidos numa sequência sintaticamente incorreta, incluindo `LIGAR();` (válido lexicalmente);
  5. erros lexicais (incluir `=` e `!` isolados);
  6. outros erros lexicais (candidatos malformados, `+`, `*`, `@`, etc.);
  7. apenas comentários e separadores → 0 tokens, 0 erros;
  8. ficheiro vazio → 0 tokens, 0 erros.
- Produzir os **resultados esperados** de cada teste.
- **Validar** o lexer do Elemento 2 contra os resultados esperados e reportar bugs.
- Montar o **ZIP final** (`TP1_num1_num2_num3.zip`) com a estrutura pedida.
- Finalizar o **relatório PDF** (máx. 4 páginas) e preparar a **demonstração** (~15 min).

**Entregáveis:** `testes/` + ZIP final + relatório completo + demo.

---

## Dependências entre elementos

- O **Elemento 2** pode começar assim que o Elemento 1 tiver as regex definidas.
- O **Elemento 3** começa cedo (escrita dos testes) e depois valida o lexer.
- **Todos** devem compreender as três partes (discussão na demonstração).

