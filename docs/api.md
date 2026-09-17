# Feather API Standards

This document defines the HTTP and OpenAPI conventions for Feather model APIs.
It applies to admin model APIs unless a feature explicitly documents a different
contract. Public APIs may use a different read model when their caching or
delivery requirements require it.

## Model API shape

A standalone admin model uses the following operations:

```text
POST   /api/v1/admin/{module}/{resource}             create
POST   /api/v1/admin/{module}/{resource}/list       collection list
POST   /api/v1/admin/{module}/{resource}/references  relation/reference list
POST   /api/v1/admin/{module}/{resource}/resolve     resolve known identifiers
GET    /api/v1/admin/{module}/{resource}/{id}       get one
PUT    /api/v1/admin/{module}/{resource}/{id}       replace
PATCH  /api/v1/admin/{module}/{resource}/{id}       update partially
DELETE /api/v1/admin/{module}/{resource}             bulk delete
```

The collection GET endpoint is not part of the admin model standard. Collection
reads use `POST /list`; relation and reference reads use `POST /references`;
known identifiers are resolved with `POST /resolve`.
Detail GET endpoints remain available for retrieving one resource by ID.

## Collection queries

Collection reads use `POST /list`. Relation and reference reads use
`POST /references`. Both endpoints accept free-text search, structured filters,
sorting, and pagination. The presence or absence of a free-text search term
does not change the endpoint.

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
    "limit": 50,
    "offset": 100
  }
}
```

### List uses

`POST /list` is used for:

- relation collections scoped by a parent resource;
- filtered collection reads for admin tables.

It is also used by every standalone admin table. Admin table requests use the
default or explicit pagination settings and may include free-text search under
`filters.search`, additional filters, and sorting. Relation and reference
requests use the same pagination settings. Resolve requests are exact batch
operations and do not use pagination.

Example:

```http
POST /api/v1/admin/web/metadata/list
Content-Type: application/json
```

```json
{
  "filters": {
    "search": "home",
    "referenceType": "web.page",
    "referenceIds": ["page_home", "page_about"]
  }
}
```

```http
POST /api/v1/admin/media/assets/list
Content-Type: application/json
```

```json
{
  "filters": {
    "ids": ["asset_logo", "asset_hero"],
    "variants": ["thumbnail", "large"]
  }
}
```

The response uses one stable envelope for all list requests:

```json
{
  "query": {
    "filters": {
      "search": "home"
    },
    "pagination": {
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

List endpoints should provide a stable, endpoint-defined ordering.

## Reference lists

`POST /references` is used when a collection is being queried to resolve
relations or populate a select, autocomplete, or other option list. It accepts
the same request body as `POST /list`, including `filters`, sorting, and
pagination, and returns the same response envelope. Its `data.items` array
contains option items rather than list items.

Example:

```http
POST /api/v1/admin/web/pages/references
Content-Type: application/json
```

```json
{
  "filters": {
    "search": "home"
  },
  "pagination": {
    "limit": 25,
    "offset": 0
  }
}
```

The references response uses the same envelope as a list response, with an
option-item array:

```json
{
  "query": {
    "filters": {
      "search": "home"
    },
    "pagination": {
      "limit": 25,
      "offset": 0
    }
  },
  "data": {
    "items": [
      {
        "value": "page_home",
        "label": "Home"
      }
    ],
    "count": 1
  }
}
```

## Relation APIs

Relation collections use a parent resource in the path and `list` for reads.
Select and reference reads for a relation use `references`.
The relation mutation remains on the relation collection path.

```text
POST   /api/v1/admin/{module}/members/{memberId}/gallery          add relation
POST   /api/v1/admin/{module}/members/{memberId}/gallery/list    list relation
POST   /api/v1/admin/{module}/members/{memberId}/gallery/references relation references
DELETE /api/v1/admin/{module}/members/{memberId}/gallery          bulk delete relations (200)
```

Relation lists use the same pagination settings as other collection reads. A
relation should not receive a separate endpoint when it needs free-text
filtering. It should use the same `/list` endpoint with `filters.search`.

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

## Resolving records

`POST /resolve` resolves known identifiers into enriched resource records. It
is not a paginated collection read, and its request and response schemas remain
resource-specific.

Metadata resolution uses a reference type and one or more reference IDs:

```http
POST /api/v1/admin/web/metadata/resolve
Content-Type: application/json
```

```json
{
  "referenceType": "web.page",
  "referenceIds": ["page_home", "page_about"]
}
```

Media asset resolution uses asset IDs and may request specific variants:

```http
POST /api/v1/admin/media/assets/resolve
Content-Type: application/json
```

```json
{
  "ids": ["asset_logo", "asset_hero"],
  "variants": ["preview"]
}
```

Resolve responses return enriched resource-specific item arrays, such as
metadata availability fields or media asset variants.

## Batch retrieval

Batch retrieval that needs enriched records uses `resolve` rather than a
legacy `search` or `query` route or suffix.

```text
POST /api/v1/admin/web/metadata/resolve
POST /api/v1/admin/media/assets/resolve
```

Batch resolution fields must express exact retrieval or enrichment concerns,
such as `referenceType`, `referenceIds`, `ids`, and `variants`.

## Naming

OpenAPI generator and client names follow the route name:

```text
{Resource}ListOperation
{Resource}List
{Resource}ReferencesOperation
{Resource}References
{Resource}ResolveOperation
{Resource}Resolve
```

Use `List`, not `Search` or `Query`, for general collection reads.
Use `References` for relation resolution and collections queried to populate
select or option controls. Collection HTTP endpoints use `list` and
`references`. Use `Resolve` for enriching records identified by IDs or
references.

The generated client methods should therefore be named like:

```swift
client.webMetadataList(...)
client.mediaAssetList(...)
client.webPageReferences(...)
client.webMetadataResolve(...)
client.mediaAssetResolve(...)
```

## Response schemas

Queries should reuse the model's list-item representation whenever
their fields are the same. A query may use a specialized list-item schema when
it returns a projection or expanded related data, such as media variants.
References endpoints return option-item representations intended for relation
select and autocomplete controls.

The response convention is:

```text
list -> ListResponse<ResourceListItemSchema>
references -> ListResponse<ResourceOptionItemSchema>
resolve -> ResourceResolveResponse
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
request controls the pagination settings, which default to a shared limit and
an offset of zero.

Contract changes must be made in the owning generator target. Regenerate the
OpenAPI YAML and generated Swift client/server/types after changing the
generator. Do not edit generated YAML or generated Swift directly.

## Migration guidance

When converting an existing collection API:

1. Move all collection callers to `{resource}List`.
2. Add pagination to admin table requests, relying on the default or providing
   explicit `pagination.limit` and `pagination.offset` values.
3. Review relation and reference callers to ensure their pagination settings
   meet their result-size requirements.
4. Move batch hydration callers to resource-specific `/resolve` routes.
5. Replace `/search` and `/query` routes with `/list` routes.
6. Replace legacy batch-resolution routes with `/resolve` routes.
7. Remove collection GET routes from the admin contract.
8. Move deletion to the collection-level bulk DELETE operation.
9. Keep detail GET routes and singleton read endpoints where they are
   semantically appropriate.
10. Regenerate the contract and update all server and client implementations.

Public/shared collection endpoints are outside this migration unless the
feature explicitly opts into the admin model standard.
