import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Menu.PathCollection().pathMap) { current, _ in current }
        paths.merge(MenuItem.PathCollection().pathMap) { current, _ in current }
        paths.merge(Metadata.PathCollection().pathMap) { current, _ in current }
        paths.merge(Page.PathCollection().pathMap) { current, _ in current }
        paths.merge(Settings.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
