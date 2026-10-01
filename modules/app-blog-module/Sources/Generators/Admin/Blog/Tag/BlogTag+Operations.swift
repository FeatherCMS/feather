import BlogSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogTagOperation: BearerProtectedOperation {
}

extension BlogTagOperation {
    public var tags: [any TagRepresentable] { [BlogTagTag()] }
}

public protocol BlogTagIDOperation: BlogTagOperation {
}

extension BlogTagIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            BlogTagIdParameter().reference()
        ]
    }
}

struct BlogTagCreateOperation: BlogTagOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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

    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
        BlogTagPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: BlogTagDetailResponse().reference(),
            404: CustomResponse(description: "BlogTag not found"),
        ]
    }
}

struct BlogTagRemoveOperation: BlogTagOperation,
    DeleteOperation
{
}
