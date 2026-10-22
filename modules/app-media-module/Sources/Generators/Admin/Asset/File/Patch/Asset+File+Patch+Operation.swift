import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Patch {
    struct Operation: Asset.File.IDOperation {
        var operationId: String? { "mediaAssetPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MediaAssetIdParameter().reference(),
                MediaAssetUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaAssetPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MediaAssetDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "MediaAsset not found"),
            ]
        }
    }
}
