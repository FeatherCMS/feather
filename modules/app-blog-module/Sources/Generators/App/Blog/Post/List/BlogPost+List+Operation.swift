import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.List {
    struct Operation: BlogOperation {
        var operationId: String? { "blogPostList" }
        var responseMap: ResponseMap {
            [200: BlogPostListResponse().reference()]
        }
    }
}
