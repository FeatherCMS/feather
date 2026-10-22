import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/posts": PathItem(),
                "api/v1/admin/blog/posts/query": Query.PathItem(),
                "api/v1/admin/blog/posts/{blogPostId}": ID.PathItem(),
            ]
        }
    }
}
