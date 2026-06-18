import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol RedirectRuleOperation: BearerProtectedOperation {
}

extension RedirectRuleOperation {
    public var tags: [TagRepresentable] { [RedirectRuleTag()] }
}

public protocol RedirectRuleIDOperation: RedirectRuleOperation {
}

extension RedirectRuleIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            RedirectRuleIdParameter().reference()
        ]
    }
}

struct RedirectRuleCreateOperation: RedirectRuleOperation {
    var requestBody: RequestBodyRepresentable? {
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

struct RedirectRuleFiltersOperation: RedirectRuleOperation {
    var responseMap: ResponseMap {
        [
            200: RedirectRuleFiltersResponse().reference()
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

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct RedirectRuleBulkDeleteOperation: RedirectRuleOperation,
    BulkDeleteOperation
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        RedirectRulePatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "RedirectRule not found"),
        ]
    }
}

struct RedirectRuleDeleteOperation: RedirectRuleIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "RedirectRule deleted"),
            404: CustomResponse(description: "RedirectRule not found"),
        ]
    }
}
