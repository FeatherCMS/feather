import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogAuthorGet" }
        var parameters: [any ParameterRepresentable] {
            [Author.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
