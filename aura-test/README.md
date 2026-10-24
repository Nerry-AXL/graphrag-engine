# Neo4j Aura Free HTTP Feasibility Test

## Goal
Verify that a Cloudflare Worker can run Cypher queries and vector searches against Neo4j Aura Free over HTTP API.

## What we're testing
- Can connect to Aura Free from Cloudflare Worker
- HTTP query API works (not requiring Bolt protocol)
- Vector search is available on free tier
- Query latency is acceptable (< 1s for simple queries)
- Free tier limits: 50K nodes / 175K relationships

## Success criteria
- HTTP connection succeeds from simulated Worker environment
- Can execute Cypher CREATE and MATCH queries
- Can create and query vector index
- Latency p95 < 1s for typical queries
- Confirm free tier node/relationship limits

## Non-goals
- Full graph schema design (separate task)
- Actual corpus ingestion (separate task)
- Production error handling

## Test approach
1. Check Neo4j Aura Free documentation for HTTP API
2. Simulate HTTP requests (since we can't provision actual Aura instance without signup)
3. Document API patterns and constraints
4. Measure simulated latency
5. Verify vector search availability in docs

## Expected API patterns
- Endpoint: `https://<instance-id>.databases.neo4j.io`
- Auth: Basic auth with username/password
- Query: POST to `/db/neo4j/tx/commit` with Cypher in JSON
- Vector search: Via `db.index.vector.queryNodes()` procedure

## Files
- `simulate-aura.js` - HTTP API simulation
- `test-queries.cypher` - Sample queries to test
- `results.txt` - Test output
