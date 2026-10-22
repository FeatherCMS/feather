import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Post {
    struct Operation: Post.Operation {
        var operationId: String? { "blogPostPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogPostDetailResponse().reference()]
        }
    }
}
