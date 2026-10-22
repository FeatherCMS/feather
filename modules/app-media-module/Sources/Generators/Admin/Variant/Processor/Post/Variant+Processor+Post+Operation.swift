import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Post {
    struct Operation: Variant.Processor.Operation {
        var operationId: String? { "mediaVariantProcessorPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaVariantProcessorCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: MediaVariantProcessorDetailResponse().reference(),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
