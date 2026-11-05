import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Get {
    struct Operation: Metadata.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "metadataGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Metadata not found"),
            ]
        }
    }
}
