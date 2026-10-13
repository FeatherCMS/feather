import BlogSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogPostOperation: BearerProtectedOperation {
}

extension BlogPostOperation {
    public var tags: [any TagRepresentable] { [BlogPostTag()] }
}

public protocol BlogPostIDOperation: BlogPostOperation {
}

extension BlogPostIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            BlogPostIdParameter().reference()
        ]
    }
}

struct BlogPostCreateOperation: BlogPostOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        BlogPostRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: BlogPostDetailResponse().reference()
        ]
    }
}

struct BlogPostListOperation: BlogPostOperation {
    var responseMap: ResponseMap {
        [
            200: BlogPostListResponse().reference()
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

    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
        BlogPostPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogPostDetailResponse().reference(),
            404: CustomResponse(description: "BlogPost not found"),
        ]
    }
}

struct BlogPostRemoveOperation: BlogPostOperation,
    DeleteOperation
{
}
