import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Variant.List {
    struct Operation: Asset.File.IDOperation {
        var operationId: String? { "mediaAssetVariantList" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "MediaAsset not found"),
            ]
        }
    }
}
