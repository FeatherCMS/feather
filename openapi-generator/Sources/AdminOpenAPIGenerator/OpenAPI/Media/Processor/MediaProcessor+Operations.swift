import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

protocol MediaProcessorOperation: BearerProtectedOperation {}

extension MediaProcessorOperation {
    var tags: [TagRepresentable] { [MediaProcessorTag()] }
}

protocol MediaProcessorIDOperation: MediaProcessorOperation {}

extension MediaProcessorIDOperation {
    var parameters: [ParameterRepresentable] {
        [MediaProcessorIdParameter().reference()]
    }
}

struct MediaProcessorCreateOperation: MediaProcessorOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaProcessorCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: MediaProcessorDetailResponse().reference()
        ]
    }
}

struct MediaProcessorSearchOperation: MediaProcessorOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: MediaProcessorListItemSchema(),
            sortFieldKeys: [
                "id",
                "name",
                "matchExtensions",
                "commandTemplate",
                "isRequired",
                "isActive",
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

struct MediaProcessorGetOperation: MediaProcessorIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaProcessorDetailResponse().reference(),
            404: CustomResponse(description: "MediaProcessor not found"),
        ]
    }
}

struct MediaProcessorUpdateOperation: MediaProcessorIDOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaProcessorCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaProcessorDetailResponse().reference(),
            404: CustomResponse(description: "MediaProcessor not found"),
        ]
    }
}

struct MediaProcessorDeleteOperation: MediaProcessorIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "MediaProcessor deleted"),
            404: CustomResponse(description: "MediaProcessor not found"),
        ]
    }
}
