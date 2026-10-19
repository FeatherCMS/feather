import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Permission.PathCollection().pathMap) { current, _ in current }
        paths.merge(Variable.PathCollection().pathMap) { current, _ in current }
        paths.merge(Job.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
