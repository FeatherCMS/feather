public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol SystemVariableOperation: BearerProtectedOperation {
}

extension SystemVariableOperation {
    public var tags: [any TagRepresentable] { [SystemVariableTag()] }
}

public protocol SystemVariableIDOperation: SystemVariableOperation {
}

extension SystemVariableIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            SystemVariableIDParameter().reference()
        ]
    }
}

struct SystemVariableCreateOperation: SystemVariableOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemVariableRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: SystemVariableDetailResponse().reference()
        ]
    }
}

struct SystemVariableListOperation: SystemVariableOperation {
    var responseMap: ResponseMap {
        [
            200: SystemVariableListResponse().reference()
        ]
    }
}

struct SystemVariableSearchOperation: SystemVariableOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: SystemVariableListItemSchema(),
            sortFieldKeys: [
                "key",
                "name",
                "value",
                "notes",
            ],
            filters: SearchFilterSchema(
                additionalProperties: ["ids": SystemVariableIDsFilter()]
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

struct SystemVariableRemoveOperation: SystemVariableOperation,
    DeleteOperation
{
}

struct SystemVariableGetOperation: SystemVariableIDOperation {
    var responseMap: ResponseMap {
        [
            200: SystemVariableDetailResponse().reference(),
            404: CustomResponse(description: "SystemVariable not found"),
        ]
    }
}

struct SystemVariableUpdateOperation: SystemVariableIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemVariableUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemVariableDetailResponse().reference(),
            404: CustomResponse(description: "SystemVariable not found"),
        ]
    }
}

struct SystemVariablePatchOperation: SystemVariableIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SystemVariablePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemVariableDetailResponse().reference(),
            404: CustomResponse(description: "SystemVariable not found"),
        ]
    }
}
