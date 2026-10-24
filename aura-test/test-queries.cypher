// Sample Cypher queries for Neo4j Aura Free testing
// These demonstrate the query patterns needed for GraphRAG

// 1. Create document node with vector embedding
CREATE (d:Document {
  id: 'doc_001',
  text: 'Introduction to graph databases',
  embedding: [0.1, 0.2, 0.3, ...] // 384-dim vector
})
RETURN d;

// 2. Create relationships between documents
MATCH (a:Document {id: 'doc_001'})
MATCH (b:Document {id: 'doc_002'})
CREATE (a)-[:REFERENCES]->(b);

// 3. Vector similarity search
CALL db.index.vector.queryNodes('document_embeddings', 5, $queryEmbedding)
YIELD node, score
WHERE score > 0.7
RETURN node.text, score
ORDER BY score DESC;

// 4. Graph traversal (multi-hop)
MATCH (start:Document {id: $startId})
MATCH path = (start)-[:REFERENCES*1..3]->(related:Document)
RETURN related.id, related.text, length(path) as hops
ORDER BY hops
LIMIT 10;

// 5. Hybrid: Vector search + graph traversal
CALL db.index.vector.queryNodes('document_embeddings', 10, $queryEmbedding)
YIELD node as doc, score
WHERE score > 0.8
MATCH path = (doc)-[:REFERENCES*1..2]->(related:Document)
RETURN
  doc.text as source_text,
  collect(DISTINCT related.text) as related_texts,
  score,
  count(path) as num_connections
ORDER BY score DESC, num_connections DESC
LIMIT 5;

// 6. Create vector index (one-time setup)
CALL db.index.vector.createNodeIndex(
  'document_embeddings',
  'Document',
  'embedding',
  384,
  'cosine'
);
