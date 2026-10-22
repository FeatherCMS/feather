import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/posts": BlogPost.PathItem(),
                "api/v1/blog/posts/{id}": BlogPost.ID.PathItem(),
            ]
        }
    }
}
