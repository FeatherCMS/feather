import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/account/register": Register.PathItem()]
        }
    }
}
