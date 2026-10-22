import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Metadata.Get {
    struct Operation: Metadata.Operation {
        var operationId: String? { "webMetadataGet" }
        var parameters: [any ParameterRepresentable] {
            [WebMetadataSlugParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: WebMetadataResponse().reference(),
                404: CustomResponse(description: "Web metadata not found"),
            ]
        }
    }
}
