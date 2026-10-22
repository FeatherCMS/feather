import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogTagGet" }
        var parameters: [any ParameterRepresentable] {
            [BlogTagIdParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
