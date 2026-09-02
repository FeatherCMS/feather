import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogAuthorOperation: BearerProtectedOperation {
}

extension BlogAuthorOperation {
    public var tags: [TagRepresentable] { [BlogAuthorTag()] }
}

public protocol BlogAuthorIDOperation: BlogAuthorOperation {
}

extension BlogAuthorIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            BlogAuthorIdParameter().reference()
        ]
    }
}

struct BlogAuthorCreateOperation: BlogAuthorOperation {
    var requestBody: RequestBodyRepresentable? {
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

    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        BlogAuthorPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorDetailResponse().reference(),
            404: CustomResponse(description: "BlogAuthor not found"),
        ]
    }
}

struct BlogAuthorDeleteOperation: BlogAuthorOperation,
    DeleteOperation
{
}
