import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Patch {
    struct Operation: Variant.Processor.IDOperation {
        var operationId: String? { "mediaVariantProcessorPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                MediaVariantIdParameter().reference(),
                MediaVariantProcessorIdParameter().reference(),
                MediaVariantProcessorUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaVariantProcessorPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: MediaVariantProcessorDetailResponse().reference(),
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
