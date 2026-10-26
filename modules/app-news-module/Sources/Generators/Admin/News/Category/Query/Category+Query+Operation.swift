import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category.Query {
    struct Operation: Category.Operation {
        var operationId: String? { "newsCategoryQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: ItemSchema(),
                sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
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
}
