import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogTagGet" }
        var parameters: [any ParameterRepresentable] {
            [Tag.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
