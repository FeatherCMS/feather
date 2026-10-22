import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PageQueryOperation: PageOperation {
    var operationId: String? { "pageQuery" }
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: PageQueryItemSchema(),
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
