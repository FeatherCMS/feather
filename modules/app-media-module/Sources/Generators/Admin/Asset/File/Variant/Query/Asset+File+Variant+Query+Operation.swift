import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Variant.Query {
    struct Operation: Asset.File.IDOperation {
        var operationId: String? { "mediaAssetVariantQuery" }
        var responseMap: ResponseMap {
            [
                200: MediaAssetVariantListResponse().reference(),
                404: CustomResponse(description: "MediaAsset not found"),
            ]
        }
    }
}
