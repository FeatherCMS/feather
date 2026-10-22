import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/posts": PathItem(),
                "api/v1/blog/posts/{id}": ID.PathItem(),
            ]
        }
    }
}
