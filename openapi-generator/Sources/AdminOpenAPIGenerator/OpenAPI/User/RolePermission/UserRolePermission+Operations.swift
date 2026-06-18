import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserRolePermissionOperation: BearerProtectedOperation {
}

extension UserRolePermissionOperation {
    public var tags: [TagRepresentable] { [UserRolePermissionTag()] }
}

public protocol UserRolePermissionIDOperation: UserRolePermissionOperation {
}

extension UserRolePermissionIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserRolePermissionRoleIdParameter().reference(),
            UserRolePermissionPermissionIdParameter().reference(),
        ]
    }
}

struct UserRolePermissionCreateOperation: UserRolePermissionOperation {
    var requestBody: RequestBodyRepresentable? {
        UserRolePermissionRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: UserRolePermissionDetailResponse().reference()
        ]
    }
}

struct UserRolePermissionSearchOperation: UserRolePermissionOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: UserRolePermissionListItemSchema(),
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

struct UserRolePermissionDeleteOperation: UserRolePermissionIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserRolePermission deleted")
        ]
    }
}
