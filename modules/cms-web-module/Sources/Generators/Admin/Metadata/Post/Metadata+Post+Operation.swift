import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Post {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataCreate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Metadata.Get.Response().reference()
            ]
        }
    }
}
