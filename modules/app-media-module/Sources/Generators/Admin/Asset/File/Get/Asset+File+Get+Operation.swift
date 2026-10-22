import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Get {
    struct Operation: Asset.File.IDOperation {
        var operationId: String? { "mediaAssetGet" }
        var responseMap: ResponseMap {
            [
                200: MediaAssetDetailResponse().reference(),
                404: CustomResponse(description: "MediaAsset not found"),
            ]
        }
    }
}
