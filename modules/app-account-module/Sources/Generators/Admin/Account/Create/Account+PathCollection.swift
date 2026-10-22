import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            ["api/v1/admin/account/users": Create.PathItem()]
        }
    }
}
