import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Resolve {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataResolve" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Response().reference()
            ]
        }
    }
}
