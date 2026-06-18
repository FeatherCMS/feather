import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

protocol MediaFolderOperation: BearerProtectedOperation {}

extension MediaFolderOperation {
    var tags: [TagRepresentable] { [MediaFolderTag()] }
}

protocol MediaFolderIDOperation: MediaFolderOperation {}

extension MediaFolderIDOperation {
    var parameters: [ParameterRepresentable] {
        [MediaFolderIdParameter().reference()]
    }
}

struct MediaFolderCreateOperation: MediaFolderOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaFolderCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: MediaFolderDetailResponse().reference()
        ]
    }
}

struct MediaFolderSearchOperation: MediaFolderOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: MediaFolderListItemSchema(),
            sortFieldKeys: [
                "id",
                "name",
                "path",
                "assetCount",
                "totalSizeBytes",
                "createdAt",
                "updatedAt",
            ],
            filters: MediaFolderFiltersSchema()
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

struct MediaFolderGetOperation: MediaFolderIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaFolderDetailResponse().reference(),
            404: CustomResponse(description: "MediaFolder not found"),
        ]
    }
}

struct MediaFolderUpdateOperation: MediaFolderIDOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaFolderPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaFolderDetailResponse().reference(),
            404: CustomResponse(description: "MediaFolder not found"),
        ]
    }
}

struct MediaFolderDeleteOperation: MediaFolderIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "MediaFolder deleted"),
            404: CustomResponse(description: "MediaFolder not found"),
        ]
    }
}
