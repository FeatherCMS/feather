import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Metadata.List {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataList" }
        var responseMap: ResponseMap {
            [
                200: Response().reference()
            ]
        }
    }
}
