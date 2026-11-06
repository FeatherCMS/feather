import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Get {
    struct Operation: Variant.IDOperation {
        var operationId: String? { "mediaVariantGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
