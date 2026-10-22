import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebMenuItemQueryOperation: WebMenuItemMenuOperation {
    var operationId: String? { "webMenuItemQuery" }
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: WebMenuItemQueryItemSchema(),
            sortFieldKeys: [
                "id",
                "label",
                "url",
                "priority",
                "permission",
                "createdAt",
                "updatedAt",
            ],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchRequestQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(
                query: SearchResponseQuerySchema(query: searchRequestQuery)
            )
            .reference()
        ]
    }
}
