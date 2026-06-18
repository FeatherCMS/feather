import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol SystemPermissionOperation: BearerProtectedOperation {
}

extension SystemPermissionOperation {
    public var tags: [TagRepresentable] { [SystemPermissionTag()] }
}

public protocol SystemPermissionIDOperation: SystemPermissionOperation {
}

extension SystemPermissionIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            SystemPermissionIdParameter().reference()
        ]
    }
}

struct SystemPermissionCreateOperation: SystemPermissionOperation {
    var requestBody: RequestBodyRepresentable? {
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

struct SystemPermissionFiltersOperation: SystemPermissionOperation {
    var responseMap: ResponseMap {
        [
            200: SystemPermissionFiltersResponse().reference()
        ]
    }
}

struct SystemPermissionSearchOperation: SystemPermissionOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: SystemPermissionListItemSchema(),
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

struct SystemPermissionBulkDeleteOperation: SystemPermissionOperation,
    BulkDeleteOperation
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        SystemPermissionPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemPermissionDetailResponse().reference(),
            404: CustomResponse(description: "SystemPermission not found"),
        ]
    }
}

struct SystemPermissionDeleteOperation: SystemPermissionIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "SystemPermission deleted"),
            404: CustomResponse(description: "SystemPermission not found"),
        ]
    }
}
