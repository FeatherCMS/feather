import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol AuthRolePermissionOperation: BearerProtectedOperation {
}

extension AuthRolePermissionOperation {
    public var tags: [TagRepresentable] { [AuthRolePermissionTag()] }
}

public protocol AuthRolePermissionIdOperation: AuthRolePermissionOperation {
}

extension AuthRolePermissionIdOperation {
    public var parameters: [ParameterRepresentable] {
        [
            AuthRolePermissionRoleIdParameter().reference(),
            AuthRolePermissionPermissionIdParameter().reference(),
        ]
    }
}

struct AuthRolePermissionCreateOperation: AuthRolePermissionOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthRolePermissionRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: AuthRolePermissionDetailResponse().reference()
        ]
    }
}

struct AuthRolePermissionSearchOperation: AuthRolePermissionOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: AuthRolePermissionListItemSchema(),
            sortFieldKeys: [
                "roleId",
                "permissionId",
            ],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct AuthRolePermissionDeleteOperation: AuthRolePermissionIdOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "AuthRolePermission deleted")
        ]
    }
}
