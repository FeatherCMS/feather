import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Get {
    struct Operation: Post.ID.Operation {
        var operationId: String? { "blogPostGet" }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
