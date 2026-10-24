import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension MenuItem.Query {
    struct Operation: MenuItem.MenuOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: MenuItemQueryItemSchema(),
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
}
