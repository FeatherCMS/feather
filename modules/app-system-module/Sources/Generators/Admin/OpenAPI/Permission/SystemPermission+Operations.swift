public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol SystemPermissionOperation: BearerProtectedOperation {
}

extension SystemPermissionOperation {
    public var tags: [any TagRepresentable] { [SystemPermissionTag()] }
}

public protocol SystemPermissionIDOperation: SystemPermissionOperation {
}

extension SystemPermissionIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            SystemPermissionIDParameter().reference()
        ]
    }
}

struct SystemPermissionCreateOperation: SystemPermissionOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemPermissionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: SystemPermissionDetailResponse().reference()
        ]
    }
}

struct SystemPermissionListOperation: SystemPermissionOperation {
    var responseMap: ResponseMap {
        [
            200: SystemPermissionListResponse().reference()
        ]
    }
}

struct SystemPermissionSearchOperation: SystemPermissionOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: SystemPermissionListItemSchema(),
            sortFieldKeys: [
                "key",
                "name",
                "notes",
            ],
            filters: SearchFilterSchema(
                additionalProperties: ["ids": SystemPermissionIDsFilter()]
            )
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct SystemPermissionRemoveOperation: SystemPermissionOperation,
    DeleteOperation
{
}

struct SystemPermissionGetOperation: SystemPermissionIDOperation {
    var responseMap: ResponseMap {
        [
            200: SystemPermissionDetailResponse().reference(),
            404: CustomResponse(description: "SystemPermission not found"),
        ]
    }
}

struct SystemPermissionUpdateOperation: SystemPermissionIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemPermissionUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemPermissionDetailResponse().reference(),
            404: CustomResponse(description: "SystemPermission not found"),
        ]
    }
}

struct SystemPermissionPatchOperation: SystemPermissionIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemPermissionPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemPermissionDetailResponse().reference(),
            404: CustomResponse(description: "SystemPermission not found"),
        ]
    }
}
