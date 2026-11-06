# cURL examples

These examples use the local Server and the generated System Admin API contract. Set a valid bearer token before calling protected Admin endpoints.

```sh
export API_BASE_URL="http://localhost:8080"
export ACCESS_TOKEN="<admin-access-token>"
```

## Check the Server

The health route does not require an API token:

```sh
curl --fail-with-body --show-error --silent \
  "$API_BASE_URL/health"
```

## List permissions

The list operation returns lightweight results. Search and limit are query parameters:

```sh
curl --fail-with-body --show-error --silent --get \
  "$API_BASE_URL/api/v1/admin/system/permissions" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --data-urlencode "search=admin" \
  --data-urlencode "limit=20"
```

## Query permissions

The query operation accepts structured search criteria in a JSON body:

```sh
curl --fail-with-body --show-error --silent \
  "$API_BASE_URL/api/v1/admin/system/permissions/query" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"filters":{"search":"admin"}}'
```

Use each module's generated OpenAPI document for its exact paths, parameters, request schemas, and response schemas. See [API standards](09-api-standards.md).
