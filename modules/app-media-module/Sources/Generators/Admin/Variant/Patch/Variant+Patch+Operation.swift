import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Patch {
    struct Operation: Variant.IDOperation {
        var operationId: String? { "mediaVariantPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Variant.Parameters.ID().reference(),
                Variant.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Variant.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
