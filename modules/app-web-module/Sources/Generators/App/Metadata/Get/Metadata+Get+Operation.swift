import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Metadata.Get {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataGet" }
        var parameters: [any ParameterRepresentable] {
            [MetadataSlugParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: MetadataResponse().reference(),
                404: CustomResponse(description: "Web metadata not found"),
            ]
        }
    }
}
