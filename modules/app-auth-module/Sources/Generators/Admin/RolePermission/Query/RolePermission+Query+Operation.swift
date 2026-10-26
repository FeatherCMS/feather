import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension RolePermission.Query {

    struct Operation: RolePermission.Operation {
        var operationId: String? { "authRolePermissionQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items:
                    Schemas
                    .Item(),
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
}
