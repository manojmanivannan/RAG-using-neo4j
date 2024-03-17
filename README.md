# RAG using Neo4j

`docker-compose up` to get the neo4j server up and running. Then locally install python requirements + jupyter to run your notebooks

![Graph](./images/graph.svg)


### Environment
You need the `.env` files with below parameters before running the `docker-compose`
```bash
NEO4J_USERNAME=
NEO4J_PASSWORD=
NEO4J_URI=neo4j://localhost:7687
OPENAI_API_KEY=
```