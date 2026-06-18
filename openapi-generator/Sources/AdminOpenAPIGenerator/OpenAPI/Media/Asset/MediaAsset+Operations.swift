import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

protocol MediaAssetOperation: BearerProtectedOperation {}

extension MediaAssetOperation {
    var tags: [TagRepresentable] { [MediaAssetTag()] }
}

protocol MediaAssetIDOperation: MediaAssetOperation {}

extension MediaAssetIDOperation {
    var parameters: [ParameterRepresentable] {
        [MediaAssetIdParameter().reference()]
    }
}

struct MediaAssetCreateOperation: MediaAssetOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaAssetCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: MediaAssetDetailResponse().reference()
        ]
    }
}

struct MediaAssetSearchOperation: MediaAssetOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: MediaAssetListItemSchema(),
            sortFieldKeys: [
                "id",
                "storageKey",
                "type",
                "sizeBytes",
                "status",
                "title",
                "createdAt",
                "updatedAt",
            ],
            filters: MediaAssetFiltersSchema()
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

struct MediaAssetGetOperation: MediaAssetIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaAssetDetailResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}

struct MediaAssetUpdateOperation: MediaAssetIDOperation {
    var requestBody: RequestBodyRepresentable? {
        MediaAssetPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaAssetDetailResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}

struct MediaAssetDeleteOperation: MediaAssetIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "MediaAsset deleted"),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}

struct MediaAssetVariantSearchOperation: MediaAssetIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaAssetVariantListResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}
