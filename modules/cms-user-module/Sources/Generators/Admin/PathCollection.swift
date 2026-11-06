import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Identity.PathCollection().pathMap) { current, _ in current }
        paths.merge(Role.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
