import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            Form.PathCollection().pathMap
        }
    }
}
