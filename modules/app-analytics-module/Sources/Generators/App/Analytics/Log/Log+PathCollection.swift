import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/analytics/logs/track": Track.PathItem()
            ]
        }
    }
}
