import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Get {
    struct Operation: Variant.IDOperation {
        var operationId: String? { "mediaVariantGet" }
        var responseMap: ResponseMap {
            [
                200: MediaVariantDetailResponse().reference(),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
