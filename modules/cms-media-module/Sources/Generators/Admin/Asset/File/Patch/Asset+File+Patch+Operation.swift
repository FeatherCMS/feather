import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Patch {
    struct Operation: Asset.File.IDOperation {
        var operationId: String? { "mediaAssetPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Asset.File.Parameters.ID().reference(),
                Asset.File.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Asset.File.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "MediaAsset not found"),
            ]
        }
    }
}
