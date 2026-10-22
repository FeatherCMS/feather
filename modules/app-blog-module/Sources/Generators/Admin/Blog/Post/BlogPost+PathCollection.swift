import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/posts": BlogPost.PathItem(),
                "api/v1/admin/blog/posts/": BlogPost.List.PathItem(),
                "api/v1/admin/blog/posts/search": BlogPost.Query.PathItem(),
                "api/v1/admin/blog/posts/{blogPostId}": BlogPost.ID.PathItem(),
            ]
        }
    }
}
