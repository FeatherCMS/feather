import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Put {
    struct Operation: Metadata.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "metadataUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Metadata.Get.Response().reference(),
                404: CustomResponse(description: "Metadata not found"),
            ]
        }
    }
}
