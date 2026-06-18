import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol BlogAuthorLinkOperation: BearerProtectedOperation {
}

extension BlogAuthorLinkOperation {
    public var tags: [TagRepresentable] { [BlogAuthorLinkTag()] }
}

public protocol BlogAuthorLinkMenuOperation: BlogAuthorLinkOperation {
}

extension BlogAuthorLinkMenuOperation {
    public var parameters: [ParameterRepresentable] {
        [
            BlogAuthorLinkMenuIdParameter().reference()
        ]
    }
}

public protocol BlogAuthorLinkIDOperation: BlogAuthorLinkMenuOperation {
}

extension BlogAuthorLinkIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            BlogAuthorLinkMenuIdParameter().reference(),
            BlogAuthorLinkIdParameter().reference(),
        ]
    }
}

struct BlogAuthorLinkCreateOperation: BlogAuthorLinkMenuOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogAuthorLinkRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: BlogAuthorLinkDetailResponse().reference()
        ]
    }
}

struct BlogAuthorLinkFiltersOperation: BlogAuthorLinkMenuOperation {
    var responseMap: ResponseMap {
        [
            200: BlogAuthorLinkFiltersResponse().reference()
        ]
    }
}

struct BlogAuthorLinkSearchOperation: BlogAuthorLinkMenuOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: BlogAuthorLinkListItemSchema(),
            sortFieldKeys: [
                "id",
                "label",
                "url",
                "priority",
                "permission",
                "createdAt",
                "updatedAt",
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

struct BlogAuthorLinkGetOperation: BlogAuthorLinkIDOperation {
    var responseMap: ResponseMap {
        [
            200: BlogAuthorLinkDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthorLink not found"),
        ]
    }
}

struct BlogAuthorLinkUpdateOperation: BlogAuthorLinkIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogAuthorLinkUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorLinkDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthorLink not found"),
        ]
    }
}

struct BlogAuthorLinkPatchOperation: BlogAuthorLinkIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogAuthorLinkPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorLinkDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthorLink not found"),
        ]
    }
}

struct BlogAuthorLinkDeleteOperation: BlogAuthorLinkIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "BlogAuthorLink deleted"),
            404: CustomResponse(description: "BlogAuthorLink not found"),
        ]
    }
}
