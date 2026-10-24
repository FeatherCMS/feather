public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/web/pages": PathItem(),
                "api/v1/admin/web/pages/": List.PathItem(),
                "api/v1/admin/web/pages/query": Query.PathItem(),
                "api/v1/admin/web/pages/{pageId}": ID.PathItem(),
            ]
        }
    }
}
