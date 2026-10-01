import BlogSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogAuthorOperation: BearerProtectedOperation {
}

extension BlogAuthorOperation {
    public var tags: [any TagRepresentable] { [BlogAuthorTag()] }
}

public protocol BlogAuthorIDOperation: BlogAuthorOperation {
}

extension BlogAuthorIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            BlogAuthorIdParameter().reference()
        ]
    }
}

struct BlogAuthorCreateOperation: BlogAuthorOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        BlogAuthorRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: BlogAuthorDetailResponse().reference()
        ]
    }
}

struct BlogAuthorListOperation: BlogAuthorOperation {
    var responseMap: ResponseMap {
        [
            200: BlogAuthorListResponse().reference()
        ]
    }
}

struct BlogAuthorSearchOperation: BlogAuthorOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: BlogAuthorListItemSchema(),
            sortFieldKeys: [
                "id",
                "key",
                "name",
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

struct BlogAuthorGetOperation: BlogAuthorIDOperation {
    var responseMap: ResponseMap {
        [
            200: BlogAuthorDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthor not found"),
        ]
    }
}

struct BlogAuthorUpdateOperation: BlogAuthorIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        BlogAuthorUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthor not found"),
        ]
    }
}

struct BlogAuthorPatchOperation: BlogAuthorIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        BlogAuthorPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthor not found"),
        ]
    }
}

struct BlogAuthorRemoveOperation: BlogAuthorOperation,
    DeleteOperation
{
}
