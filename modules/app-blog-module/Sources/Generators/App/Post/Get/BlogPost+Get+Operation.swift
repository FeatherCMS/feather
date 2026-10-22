import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Get {
    struct Operation: BlogOperation {
        var operationId: String? { "blogPostGet" }
        var parameters: [any ParameterRepresentable] {
            [BlogPostIdParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
