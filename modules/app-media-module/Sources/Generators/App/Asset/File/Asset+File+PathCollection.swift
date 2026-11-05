import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/media/assets/resolve": Resolve.PathItem()]
        }
    }
}
