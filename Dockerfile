FROM neo4j:5.18.0-enterprise


RUN apt install --quiet procps

COPY ./scripts/create-graph.sh create-graph.sh
COPY ./scripts/wrapper.sh wrapper.sh
COPY ./scripts/create-nodes.cypher create-nodes.cypher

ENTRYPOINT ["./wrapper.sh"]