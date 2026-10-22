public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

public protocol AuthRolePermissionOperation: BearerProtectedOperation {
}

extension AuthRolePermissionOperation {
    public var tags: [any TagRepresentable] { [AuthRolePermissionTag()] }
}

public protocol AuthRolePermissionIdOperation: AuthRolePermissionOperation {
}

extension AuthRolePermissionIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            AuthRolePermissionRoleIdParameter().reference(),
            AuthRolePermissionPermissionIdParameter().reference(),
        ]
    }
}

struct AuthRolePermissionCreateOperation: AuthRolePermissionOperation {
    var operationId: String? { "authRolePermissionCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthRolePermissionRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: AuthRolePermissionDetailResponse().reference()
        ]
    }
}

struct AuthRolePermissionQueryOperation: AuthRolePermissionOperation {
    var operationId: String? { "authRolePermissionQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthRolePermissionQueryItemSchema(),
            sortFieldKeys: [
                "roleId",
                "permissionId",
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

struct AuthRolePermissionRemoveOperation: AuthRolePermissionOperation,
    DeleteOperation
{
    var operationId: String? { "authRolePermissionRemove" }
}
