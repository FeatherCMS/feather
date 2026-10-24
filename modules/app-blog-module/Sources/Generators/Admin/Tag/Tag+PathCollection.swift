import BlogSchemaSupport
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/tags": PathItem(),
                "api/v1/admin/blog/tags/query": Query.PathItem(),
                "api/v1/admin/blog/tags/{blogTagId}": ID.PathItem(),
            ]
        }
    }
}
