import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/tags": PathItem(),
                "api/v1/blog/tags/{id}": ID.PathItem(),
            ]
        }
    }
}
