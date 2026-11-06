import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Get {
    struct Operation: Variant.Processor.IDOperation {
        var operationId: String? { "mediaVariantProcessorGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(
                    description: "Media variant processor not found"
                ),
            ]
        }
    }
}
