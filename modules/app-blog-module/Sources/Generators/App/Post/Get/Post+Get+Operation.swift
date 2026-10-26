import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogPostGet" }
        var parameters: [any ParameterRepresentable] {
            [Post.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
