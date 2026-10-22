import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.List {
    struct Operation: BlogPost.Operation {
        var operationId: String? { "blogPostList" }
        var responseMap: ResponseMap {
            [200: BlogPostListResponse().reference()]
        }
    }
}
