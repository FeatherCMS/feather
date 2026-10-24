import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Metadata.Resolve {
    struct Operation: Metadata.Operation, BearerProtectedOperation {
        var operationId: String? { "metadataResolve" }
        var requestBody: (any RequestBodyRepresentable)? {
            MetadataResolveRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MetadataResolveResponse().reference()
            ]
        }
    }
}
