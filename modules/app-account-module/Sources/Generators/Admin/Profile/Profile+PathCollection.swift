import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/account/users/{userId}/profile": PathItem(),
                "api/v1/admin/account/profile": CurrentUser.PathItem(),
            ]
        }
    }
}
