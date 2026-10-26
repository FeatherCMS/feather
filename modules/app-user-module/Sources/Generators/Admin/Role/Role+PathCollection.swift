import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/user/roles": PathItem(),
                "api/v1/admin/user/roles/query": Query.PathItem(),
                "api/v1/admin/user/roles/{userRoleId}": ID.PathItem(),
            ]
        }
    }
}
