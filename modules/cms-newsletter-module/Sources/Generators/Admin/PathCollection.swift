import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Campaign.PathCollection().pathMap) {
            current,
            _ in current
        }
        paths.merge(Issue.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(Delivery.PathCollection().pathMap) {
            current,
            _ in current
        }
        paths.merge(Subscriber.PathCollection().pathMap) {
            current,
            _ in current
        }
        return paths
    }
}
