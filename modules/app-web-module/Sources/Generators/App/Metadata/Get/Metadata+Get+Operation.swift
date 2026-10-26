import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata.Get {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataGet" }
        var parameters: [any ParameterRepresentable] {
            [Metadata.Parameters.Slug().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Web metadata not found"),
            ]
        }
    }
}
