import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        Campaign.PathCollection().pathMap
    }
}
