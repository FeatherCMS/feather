import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthRolePermissionQueryOperation: AuthRolePermissionOperation {
    var operationId: String? { "authRolePermissionQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthRolePermissionQueryItemSchema(),
            sortFieldKeys: ["roleId", "permissionId"],
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
