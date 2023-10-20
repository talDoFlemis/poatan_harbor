# Trabalho Prático 1

## Dupla

- ANDRE WILLYAN DE SOUSA VITAL - 537550
- SAID CAVALCANTE RODRIGUES - 538349

## Diagrama Entidade Relacionamento

O Diagrama se encontra neste repositório no arquivo `diagrama.drawio`, mas também pode ser obtido pelo [link](https://drive.google.com/file/d/1jY5N2cmNLedmkrCaplbMV5UdeteGBD3G/view?usp=sharing)

## Dicionário de Dados

O dicionário de dados se encontra neste repositório no arquivo `dicionario.pdf`, mas também pode ser visto pelo [link](https://www.canva.com/design/DAFxqJW3x18/1e-LUwC9Jijl3cq-PwopJA/edit?utm_content=DAFxqJW3x18&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## Esquema de Definição das Tabelas

O esquema de definição tabelas se encontra no arquivo `sql/aggregate.sql`, que pode ser montando a partir do banco de dados local provido pelo `docker-compose.yml`

1. Inicie o banco de dados local

```bash
docker compose up
```

2. Faça a inserção das tabelas de definição em outro terminal após o banco de dados inicializar

```bash
export PGPASSWORD="senha"; psql -h localhost -U admin -d poatan < sql/aggregate.sql
```

3. Faça o seed do banco de dados se for necessário

```bash
bun index.ts
```

## Banco de Dados implementado

O banco de dados implementado no LSBD se encontra no banco `poatan_538349_TP1`
