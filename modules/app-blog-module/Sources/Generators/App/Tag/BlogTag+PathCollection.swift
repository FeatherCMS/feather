import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/blog/tags": BlogTag.PathItem(),
                "api/v1/blog/tags/{id}": BlogTag.ID.PathItem(),
            ]
        }
    }
}
