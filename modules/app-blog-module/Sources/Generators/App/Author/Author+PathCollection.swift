import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/authors": PathItem(),
                "api/v1/blog/authors/{id}": ID.PathItem(),
            ]
        }
    }
}
