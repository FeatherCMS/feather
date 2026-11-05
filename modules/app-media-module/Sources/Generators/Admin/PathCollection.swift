import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        var paths: PathMap = [:]
        paths.merge(Asset.File.PathCollection().pathMap) { current, _ in current
        }
        paths.merge(Asset.Folder.PathCollection().pathMap) { current, _ in
            current
        }
        paths.merge(Variant.PathCollection().pathMap) { current, _ in current }
        return paths
    }
}
