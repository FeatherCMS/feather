import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Post {
    struct Operation: Asset.File.Operation {
        var operationId: String? { "mediaAssetPost" }
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
}
