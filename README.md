# Mining robots Multiagente

## Sobre

Este projeto simula um ambiente onde agentes mineradores atuam de forma autônoma e colaborativa para localizar e coletar recursos. Através de um sistema multiagente, cada robô toma decisões com base em sua percepção local e coordenação com outros agentes.

Foram utilizados conceitos como:
- Agentes deliberativos;
- Comunicação e cooperação entre agentes;
- Ambiente parcialmente observável;
- Planejamento baseado em regras.

## Estrutura do Projeto

```plaintext
mining-robots/
└── mining-robots/
    ├── builder.asl                       # Código do agente construtor
    ├── col.asl                           # Código do agente coletor
    ├── resourceCollection.mas2j          # Configuração do sistema multiagente Jason
    ├── build.gradle                      # Configuração do Gradle
    ├── settings.gradle                   # Configuração do Gradle
    └── logging.properties                # Configuração de logs
```

## Como Executar

### Pré-requisitos

- Java JDK (versão 8 ou superior)
- [Jason IDE](https://github.com/jason-lang/jason) ou outro ambiente compatível com arquivos `.asl` e `.mas2j`
- Gradle (opcional, se quiser compilar pelo terminal)

### Execução

1. Abra o projeto no Jason IDE.
2. Execute o arquivo `resourceCollection.mas2j`.
3. Observe os agentes atuando no ambiente
