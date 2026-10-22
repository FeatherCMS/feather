import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/account/profile": PathItem()]
        }
    }
}
