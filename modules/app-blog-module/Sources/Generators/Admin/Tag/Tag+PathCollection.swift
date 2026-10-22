import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/blog/tags": BlogTag.PathItem(),
                "api/v1/admin/blog/tags/query": BlogTag.Query.PathItem(),
                "api/v1/admin/blog/tags/{blogTagId}": BlogTag.ID.PathItem(),
            ]
        }
    }
}
