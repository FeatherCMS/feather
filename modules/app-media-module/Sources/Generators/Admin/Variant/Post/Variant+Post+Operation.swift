import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Post {
    struct Operation: Variant.Operation {
        var operationId: String? { "mediaVariantPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaVariantCreateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: MediaVariantDetailResponse().reference()]
        }
    }
}
