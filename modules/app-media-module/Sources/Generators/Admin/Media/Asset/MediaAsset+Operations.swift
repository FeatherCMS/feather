import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol MediaAssetOperation: BearerProtectedOperation {}

extension MediaAssetOperation {
    var tags: [any TagRepresentable] { [MediaAssetTag()] }
}

protocol MediaAssetIDOperation: MediaAssetOperation {}

extension MediaAssetIDOperation {
    var parameters: [any ParameterRepresentable] {
        [MediaAssetIdParameter().reference()]
    }
}

struct MediaAssetCreateOperation: MediaAssetOperation {
    var parameters: [any ParameterRepresentable] {
        [
            MediaAssetParentIDHeader().reference(),
            MediaAssetFileNameHeader().reference(),
            MediaAssetExtensionHeader().reference(),
            MediaAssetTitleHeader().reference(),
            MediaAssetAltTextHeader().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        MediaAssetCreateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: MediaAssetDetailResponse().reference(),
            409: CustomResponse(
                description: "A media asset with this path already exists"
            ),
        ]
    }
}

struct MediaAssetListOperation: MediaAssetOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: MediaAssetNodeSearchItemSchema(),
            sortFieldKeys: [
                "id",
                "name",
                "slugPath",
                "extension",
                "sizeBytes",
                "status",
                "title",
                "createdAt",
                "updatedAt",
            ],
            filters: MediaAssetFiltersSchema()
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

struct MediaAssetGetOperation: MediaAssetIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaAssetDetailResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}

struct MediaAssetResolveOperation: MediaAssetOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MediaAssetResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaAssetResolveResponse().reference()
        ]
    }
}

struct MediaAssetUpdateOperation: MediaAssetIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        MediaAssetPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaAssetDetailResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}

struct MediaAssetNodeRemoveOperation: MediaAssetOperation,
    DeleteOperation
{
}

struct MediaAssetVariantSearchOperation: MediaAssetIDOperation {
    var responseMap: ResponseMap {
        [
            200: MediaAssetVariantListResponse().reference(),
            404: CustomResponse(description: "MediaAsset not found"),
        ]
    }
}
