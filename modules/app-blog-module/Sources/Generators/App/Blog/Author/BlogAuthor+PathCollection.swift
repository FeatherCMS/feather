import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/authors": BlogAuthor.PathItem(),
                "api/v1/blog/authors/{id}": BlogAuthor.ID.PathItem(),
            ]
        }
    }
}
