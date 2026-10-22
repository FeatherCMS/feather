import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebPageQueryOperation: WebPageOperation {
    var operationId: String? { "webPageQuery" }
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: WebPageQueryItemSchema(),
            sortFieldKeys: [
                "id",
                "title",
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
