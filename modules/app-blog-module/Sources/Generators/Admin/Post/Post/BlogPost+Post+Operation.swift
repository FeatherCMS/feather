import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Post {
    struct Operation: BlogPost.Operation {
        var operationId: String? { "blogPostPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogPostDetailResponse().reference()]
        }
    }
}
