# Feather API Standards

This document defines the HTTP and OpenAPI conventions for Feather model APIs.
It applies to admin model APIs unless a feature explicitly documents a different
contract. Public APIs may use a different read model when their caching or
delivery requirements require it.

## Model API shape

A standalone admin model uses the following operations:

```text
POST   /api/v1/admin/{module}/{resource}             create
POST   /api/v1/admin/{module}/{resource}/query      collection query
GET    /api/v1/admin/{module}/{resource}/{id}       get one
PUT    /api/v1/admin/{module}/{resource}/{id}       replace
PATCH  /api/v1/admin/{module}/{resource}/{id}       update partially
DELETE /api/v1/admin/{module}/{resource}             bulk delete
```

The collection GET endpoint is not part of the admin model standard. Read
operations that return collections use `POST /query`.
Detail GET endpoints remain available for retrieving one resource by ID.

## Collection queries

All collection reads use `POST /query`. The request can contain free-text
search, structured filters, sorting, and pagination. The presence or absence of
a free-text search term does not change the endpoint.

### Pagination

Pagination is enabled by default. If `pagination` is omitted, the server applies
the shared default limit and an offset of zero:

```json
{
  "filters": {
    "search": "home"
  }
}
```

The effective pagination is:

```json
{
  "disabled": false,
  "limit": 25,
  "offset": 0
}
```

Clients may provide an explicit paginated request:

```json
{
  "filters": {
    "search": "home"
  },
  "pagination": {
    "disabled": false,
    "limit": 50,
    "offset": 100
  }
}
```

Non-paginated queries must explicitly disable pagination:

```json
{
  "filters": {
    "search": "home",
    "referenceIds": ["page_home", "page_about"]
  },
  "pagination": {
    "disabled": true
  }
}
```

When pagination is disabled, `limit` and `offset` must not be supplied. The
server should
still enforce a maximum result size for non-paginated queries.

### Query uses

`POST /query` is used for:

- relation collections scoped by a parent resource;
- exact retrieval by one or more IDs;
- exact retrieval by references or other structural criteria;
- option and selector data;
- batch hydration of known records.

It is also used by every standalone admin table. Admin table requests use the
default or explicit pagination settings and may include free-text search under
`filters.search`, additional filters, and sorting. Relation, option, and batch
requests explicitly disable pagination.

Example:

```http
POST /api/v1/admin/web/metadata/query
Content-Type: application/json
```

```json
{
  "filters": {
    "search": "home",
    "referenceType": "web.page",
    "referenceIds": ["page_home", "page_about"]
  },
  "pagination": {
    "disabled": true
  }
}
```

```http
POST /api/v1/admin/media/assets/query
Content-Type: application/json
```

```json
{
  "filters": {
    "ids": ["asset_logo", "asset_hero"],
    "variants": ["thumbnail", "large"]
  },
  "pagination": {
    "disabled": true
  }
}
```

The response uses one stable envelope for both paginated and non-paginated
queries:

```json
{
  "query": {
    "filters": {
      "search": "home"
    },
    "pagination": {
      "disabled": false,
      "limit": 25,
      "offset": 0
    }
  },
  "data": {
    "items": [
      {
        "id": "asset_logo",
        "storageKey": "images/logo.svg",
        "variants": []
      }
    ],
    "count": 137
  }
}
```

The response does not add page-count or navigation fields. For a paginated
response, the pagination values are available in `query.pagination` and the
matching record count is available in `data.count`:

```json
{
  "query": {
    "pagination": {
      "disabled": false,
      "limit": 25,
      "offset": 50
    }
  },
  "data": {
    "items": [],
    "count": 137
  }
}
```

Query endpoints should provide a stable, endpoint-defined ordering.

## Relation APIs

Relation collections use a parent resource in the path and `query` for reads.
The relation mutation remains on the relation collection path.

```text
POST   /api/v1/admin/{module}/members/{memberId}/gallery          add relation
POST   /api/v1/admin/{module}/members/{memberId}/gallery/query   query relation
DELETE /api/v1/admin/{module}/members/{memberId}/gallery          bulk delete relations (200)
```

Relation queries must explicitly disable pagination. A relation should not
receive a separate endpoint when it needs free-text filtering. It should use
the same `/query` endpoint with `filters.search`. Pagination can remain enabled
only when the relation is independently managed as a large admin table.

Relation deletion is also bulk deletion. The request contains the IDs of the
relations to remove; there is no per-relation DELETE endpoint. Relation delete
responses use the same `200` response envelope as model deletion:

```http
DELETE /api/v1/admin/{module}/members/{memberId}/gallery
Content-Type: application/json
```

```json
{
  "ids": ["asset_1", "asset_2"],
  "results": true,
  "summary": true
}
```

This contract also applies to nested relation resources such as newsletter
subscribers, newsletter issues, and auth emails.

## Bulk deletion

All model deletion uses `DELETE` on the collection resource with the standard
delete request body and returns `200 OK`. The body identifies one or more
records and controls which delete details are returned. `204 No Content` is not
used for bulk deletion.

```http
DELETE /api/v1/admin/{module}/{resource}
Content-Type: application/json
```

```json
{
  "ids": ["resource_1", "resource_2"],
  "results": true,
  "summary": true
}
```

The response may include per-ID results and a summary:

```json
{
  "results": [
    {
      "id": "resource_1",
      "status": "deleted"
    },
    {
      "id": "resource_2",
      "status": "not_found"
    }
  ],
  "summary": {
    "requested": 2,
    "deleted": 1,
    "omitted": 1
  }
}
```

The supported result statuses are `deleted`, `not_found`, and `forbidden`.
Do not add per-resource `DELETE /{id}` routes.

## Batch retrieval

Batch retrieval uses `query` rather than a `lookup` or `search` route or suffix.

```text
POST /api/v1/admin/web/metadata/query
POST /api/v1/admin/media/assets/query
```

Batch query fields must express exact retrieval or projection concerns, such as
`filters.ids`, `filters.referenceType`, `filters.referenceIds`, and
`filters.variants`. Free-text search is supplied as `filters.search`. Batch
callers must explicitly disable pagination with `pagination.disabled: true`.

## Naming

OpenAPI generator and client names follow the route name:

```text
{Resource}QueryOperation
{Resource}Query
```

Use `Query`, not `Lookup` or `Search`, for collection reads. Use `List` only
for internal application or database operations when it describes the local
operation. Collection HTTP endpoints use `query`.

The generated client methods should therefore be named like:

```swift
client.webMetadataQuery(...)
client.mediaAssetQuery(...)
```

## Response schemas

Queries should reuse the model's list-item representation whenever
their fields are the same. A query may use a specialized list-item schema when
it returns a projection or expanded related data, such as media variants.

The response convention is:

```text
query -> QueryResponse<ResourceListItemSchema>
```

Create and detail operations return detail schemas. Request and response
schemas remain transport types; domain and application layers must not depend on
OpenAPI types.

## Implementation rules

API handlers should remain thin:

1. Decode the generated input.
2. Require the current subject and authorization.
3. Map the input to an application query.
4. Execute the appropriate use case.
5. Map the result to the generated response schema.

The same application list/query use case may serve every query. The transport
request controls whether pagination is enabled; pagination is enabled by
default and must be explicitly disabled for relation, option, and batch reads.

Contract changes must be made in the owning generator target. Regenerate the
OpenAPI YAML and generated Swift client/server/types after changing the
generator. Do not edit generated YAML or generated Swift directly.

## Migration guidance

When converting an existing collection API:

1. Move all collection callers to `{resource}Query`.
2. Add pagination to admin table requests, relying on the default or providing
   explicit `pagination.limit` and `pagination.offset` values.
3. Explicitly disable pagination for relation, option, and batch callers.
4. Replace `/lookup` and `/search` routes with `/query` routes.
5. Remove collection GET routes from the admin contract.
6. Move deletion to the collection-level bulk DELETE operation.
7. Keep detail GET routes and singleton read endpoints where they are
   semantically appropriate.
8. Regenerate the contract and update all server and client implementations.

Public/shared collection endpoints are outside this migration unless the
feature explicitly opts into the admin model standard.
