import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

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

struct BlogTagFiltersOperation: BlogTagOperation {
    var responseMap: ResponseMap {
        [
            200: BlogTagFiltersResponse().reference()
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

struct BlogTagDeleteOperation: BlogTagIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "BlogTag deleted"),
            404: CustomResponse(description: "BlogTag not found"),
        ]
    }
}
