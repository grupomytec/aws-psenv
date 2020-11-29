# aws-psenv

> Um script para obter variáveis da AWS SSM Parameter Store a partir de uma path em um formato JSON compatível com a sintaxe de variáveis de ambiente das tasks definitions da Amazon ECS (parâmetro "environment").

## Como usar?

```
./aws-psenv.sh <ssm_path>
```

## Referências

- [AWS CLI: get-parameters-by-path](https://docs.aws.amazon.com/cli/latest/reference/ssm/get-parameters-by-path.html)
- [Task definition parameters: environment](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definition_environment)-
