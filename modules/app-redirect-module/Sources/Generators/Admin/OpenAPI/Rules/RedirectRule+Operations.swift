public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol RedirectRuleOperation: BearerProtectedOperation {
}

extension RedirectRuleOperation {
    public var tags: [any TagRepresentable] { [RedirectRuleTag()] }
}

public protocol RedirectRuleIDOperation: RedirectRuleOperation {
}

extension RedirectRuleIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            RedirectRuleIdParameter().reference()
        ]
    }
}

struct RedirectRuleCreateOperation: RedirectRuleOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRuleRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: RedirectRuleDetailResponse().reference()
        ]
    }
}

struct RedirectRuleListOperation: RedirectRuleOperation {
    var responseMap: ResponseMap {
        [
            200: RedirectRuleListResponse().reference()
        ]
    }
}

struct RedirectRuleSearchOperation: RedirectRuleOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: RedirectRuleListItemSchema(),
            sortFieldKeys: [
                "id",
                "source",
                "destination",
                "statusCode",
                "notes",
            ],
            filters: RedirectRuleFiltersSchema()
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

struct RedirectRuleRemoveOperation: RedirectRuleOperation,
    DeleteOperation
{
}

struct RedirectRuleGetOperation: RedirectRuleIDOperation {
    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "RedirectRule not found"),
        ]
    }
}

struct RedirectRuleUpdateOperation: RedirectRuleIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRuleUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "RedirectRule not found"),
        ]
    }
}

struct RedirectRulePatchOperation: RedirectRuleIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRulePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "RedirectRule not found"),
        ]
    }
}
