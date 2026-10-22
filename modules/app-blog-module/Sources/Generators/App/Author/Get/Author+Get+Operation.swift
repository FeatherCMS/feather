import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogAuthorGet" }
        var parameters: [any ParameterRepresentable] {
            [BlogAuthorIdParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorDetailResponse().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
