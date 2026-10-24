import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/account/settings": PathItem(),
                "api/v1/admin/account/users/{userId}/settings":
                    User.PathItem(),
            ]
        }
    }
}
