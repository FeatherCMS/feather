import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Get {
    struct Operation: BlogPost.ID.Operation {
        var operationId: String? { "blogPostGet" }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
