import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Metadata.Root {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataRootGet" }
        var responseMap: ResponseMap {
            [
                200: MetadataResponse().reference(),
                404: CustomResponse(description: "Web metadata not found"),
            ]
        }
    }
}
