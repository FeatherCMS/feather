import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Rule.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
