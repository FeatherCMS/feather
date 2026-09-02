import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogTagOperation: BearerProtectedOperation {
}

extension BlogTagOperation {
    public var tags: [TagRepresentable] { [BlogTagTag()] }
}

public protocol BlogTagIDOperation: BlogTagOperation {
}

extension BlogTagIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            BlogTagIdParameter().reference()
        ]
    }
}

struct BlogTagCreateOperation: BlogTagOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogTagRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: BlogTagDetailResponse().reference()
        ]
    }
}

struct BlogTagListOperation: BlogTagOperation {
    var responseMap: ResponseMap {
        [
            200: BlogTagListResponse().reference()
        ]
    }
}

struct BlogTagSearchOperation: BlogTagOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: BlogTagListItemSchema(),
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

struct BlogTagGetOperation: BlogTagIDOperation {
    var responseMap: ResponseMap {
        [
            200: BlogTagDetailResponse().reference(),
            404: CustomResponse(description: "BlogTag not found"),
        ]
    }
}

struct BlogTagUpdateOperation: BlogTagIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogTagUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogTagDetailResponse().reference(),
            404: CustomResponse(description: "BlogTag not found"),
        ]
    }
}

struct BlogTagPatchOperation: BlogTagIDOperation {
    var requestBody: RequestBodyRepresentable? {
        BlogTagPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogTagDetailResponse().reference(),
            404: CustomResponse(description: "BlogTag not found"),
        ]
    }
}

struct BlogTagDeleteOperation: BlogTagOperation,
    DeleteOperation
{
}
