import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Patch {
    struct Operation: Variant.IDOperation {
        var operationId: String? { "mediaVariantPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MediaVariantIdParameter().reference(),
                MediaVariantUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaVariantPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MediaVariantDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
