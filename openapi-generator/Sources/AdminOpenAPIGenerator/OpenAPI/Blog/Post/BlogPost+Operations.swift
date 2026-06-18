import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol BlogPostOperation: BearerProtectedOperation {
}

extension BlogPostOperation {
    public var tags: [TagRepresentable] { [BlogPostTag()] }
}

public protocol BlogPostIDOperation: BlogPostOperation {
}

extension BlogPostIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            BlogPostIdParameter().reference()
        ]
    }
}

struct BlogPostCreateOperation: BlogPostOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogPostRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: BlogPostDetailResponse().reference()
        ]
    }
}

struct BlogPostFiltersOperation: BlogPostOperation {
    var responseMap: ResponseMap {
        [
            200: BlogPostFiltersResponse().reference()
        ]
    }
}

struct BlogPostSearchOperation: BlogPostOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: BlogPostListItemSchema(),
            sortFieldKeys: [
                "id",
                "title",
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

struct BlogPostGetOperation: BlogPostIDOperation {
    var responseMap: ResponseMap {
        [
            200: BlogPostDetailResponse().reference(),
            404: CustomResponse(description: "BlogPost not found"),
        ]
    }
}

struct BlogPostUpdateOperation: BlogPostIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogPostUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogPostDetailResponse().reference(),
            404: CustomResponse(description: "BlogPost not found"),
        ]
    }
}

struct BlogPostPatchOperation: BlogPostIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogPostPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogPostDetailResponse().reference(),
            404: CustomResponse(description: "BlogPost not found"),
        ]
    }
}

struct BlogPostDeleteOperation: BlogPostIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "BlogPost deleted"),
            404: CustomResponse(description: "BlogPost not found"),
        ]
    }
}
