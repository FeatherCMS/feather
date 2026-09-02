import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol SystemVariableOperation: BearerProtectedOperation {
}

extension SystemVariableOperation {
    public var tags: [TagRepresentable] { [SystemVariableTag()] }
}

public protocol SystemVariableIDOperation: SystemVariableOperation {
}

extension SystemVariableIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            SystemVariableIdParameter().reference()
        ]
    }
}

struct SystemVariableCreateOperation: SystemVariableOperation {
    var requestBody: RequestBodyRepresentable? {
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
                "id",
                "name",
                "value",
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

struct SystemVariableDeleteOperation: SystemVariableOperation,
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        SystemVariablePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: SystemVariableDetailResponse().reference(),
            404: CustomResponse(description: "SystemVariable not found"),
        ]
    }
}
