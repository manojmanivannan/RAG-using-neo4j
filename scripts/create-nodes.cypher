// Create person nodes with random properties
UNWIND range(1, 20) AS id
CREATE (:Person {
  id: id,
  name: 'Person' + id,
  age: toInteger(rand() * 40) + 20,  // Age between 20 and 59
  salary: toInteger(rand() * 5000) + 3000, // Salary between 3000 and 7999
  address: 'Address' + id
});

// Create company nodes with random properties
UNWIND range(1, 5) AS companyId
CREATE (:Company {
  id: companyId,
  name: 'Company' + companyId,
  address: 'CompanyAddress' + companyId
});

// Connect persons to companies randomly
MATCH (p:Person), (c:Company)
WITH p, c
ORDER BY rand()
LIMIT 1  // Limit the number of companies for each person to one
CREATE (p)-[:WORKS_FOR]->(c);

// Ensure each company has at least one employee
MATCH (c:Company)
WHERE NOT (c)<-[:WORKS_FOR]-()
MATCH (p:Person)
WHERE NOT (p)-[:HAS_WIFE]->() AND NOT (p)-[:HAS_SON]->() AND NOT (p)-[:HAS_DAUGHTER]->()
WITH c, p
ORDER BY rand()
LIMIT 5
CREATE (p)-[:WORKS_FOR]->(c);


// Create wife, son, daughter nodes for each person
MATCH (p:Person)
WITH p
CREATE (p)-[:HAS_WIFE]->(:Person {
  name: 'Wife of ' + p.name,
  age: toInteger(rand() * 15) + 20  // Age between 20 and 34
})

WITH p
CREATE (p)-[:HAS_SON]->(:Person {
  name: 'Son of ' + p.name,
  age: toInteger(rand() * 10) + 1  // Age between 1 and 10
})

WITH p
CREATE (p)-[:HAS_DAUGHTER]->(:Person {
  name: 'Daughter of ' + p.name,
  age: toInteger(rand() * 10) + 1  // Age between 1 and 10
});

// Match all persons
MATCH (p1:Person), (p2:Person)
WHERE p1 <> p2 AND NOT (p1)-[:FRIENDS_WITH]->(p2) AND rand() < 0.5 // Adjust the probability of friendship as needed
WITH p1, p2
LIMIT 5 // Limit the number of friendships created, adjust as needed
CREATE (p1)-[:FRIENDS_WITH]->(p2);

// Find all companies without any employees
MATCH (c:Company)
WHERE NOT (c)<-[:WORKS_FOR]-()
WITH collect(c) AS companies

// Find original persons who don't work for any company
MATCH (p:Person)
WHERE NOT (p)-[:WORKS_FOR]->() AND (p)-[:HAS_SON]->()
WITH companies, collect(p) AS persons

// Create relationships between companies without employees and original persons who don't work for any company
UNWIND companies AS company
UNWIND persons AS person
CREATE (person)-[:WORKS_FOR]->(company);
