import BlogSchemaSupport
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/blog/settings": PathItem()]
        }
    }
}
