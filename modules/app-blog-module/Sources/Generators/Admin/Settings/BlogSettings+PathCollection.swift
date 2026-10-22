import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogSettings {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/admin/blog/settings": BlogSettings.PathItem()]
        }
    }
}
