import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/analytics/logs/": List.PathItem(),
                "api/v1/admin/analytics/logs/overview": Overview.PathItem(),
                "api/v1/admin/analytics/logs/query": Query.PathItem(),
                "api/v1/admin/analytics/logs/{id}": ID.PathItem(),
            ]
        }
    }
}
