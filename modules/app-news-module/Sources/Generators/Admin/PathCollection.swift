import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Article.PathCollection().pathMap) { current, _ in current }
        paths.merge(Category.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
