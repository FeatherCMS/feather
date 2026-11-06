import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/account/invitation/exchange":
                    PathItem()
            ]
        }
    }
}
