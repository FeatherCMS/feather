import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Patch {
    struct Operation: Variant.Processor.IDOperation {
        var operationId: String? { "mediaVariantProcessorPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Variant.Parameters.ID().reference(),
                Variant.Processor.Parameters.ID().reference(),
                Variant.Processor.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Variant.Processor.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask"
                ),
                404: CustomResponse(
                    description: "Media variant processor not found"
                ),
            ]
        }
    }
}
