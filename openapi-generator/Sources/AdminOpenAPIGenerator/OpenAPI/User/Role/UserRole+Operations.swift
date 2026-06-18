import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserRoleOperation: BearerProtectedOperation {
}

extension UserRoleOperation {
    public var tags: [TagRepresentable] { [UserRoleTag()] }
}

public protocol UserRoleIDOperation: UserRoleOperation {
}

extension UserRoleIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserRoleIdParameter().reference()
        ]
    }
}

struct UserRoleCreateOperation: UserRoleOperation {
    var requestBody: RequestBodyRepresentable? {
        UserRoleRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: UserRoleDetailResponse().reference()
        ]
    }
}

struct UserRoleListOperation: UserRoleOperation {
    var responseMap: ResponseMap {
        [
            200: UserRoleListResponse().reference()
        ]
    }
}

struct UserRoleFiltersOperation: UserRoleOperation {
    var responseMap: ResponseMap {
        [
            200: UserRoleFiltersResponse().reference()
        ]
    }
}

struct UserRoleSearchOperation: UserRoleOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: UserRoleListItemSchema(),
            sortFieldKeys: [
                "id",
                "name",
                "notes",
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

struct UserRoleBulkDeleteOperation: UserRoleOperation, BulkDeleteOperation {
}

struct UserRoleGetOperation: UserRoleIDOperation {
    var responseMap: ResponseMap {
        [
            200: UserRoleDetailResponse().reference(),
            404: CustomResponse(description: "UserRole not found"),
        ]
    }
}

struct UserRoleUpdateOperation: UserRoleIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserRoleUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserRoleDetailResponse().reference(),
            404: CustomResponse(description: "UserRole not found"),
        ]
    }
}

struct UserRolePatchOperation: UserRoleIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserRolePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserRoleDetailResponse().reference(),
            404: CustomResponse(description: "UserRole not found"),
        ]
    }
}

struct UserRoleDeleteOperation: UserRoleIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserRole deleted"),
            404: CustomResponse(description: "UserRole not found"),
        ]
    }
}
