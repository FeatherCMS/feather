import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/user/identities": PathItem(),
                "api/v1/admin/user/identities/query": Query.PathItem(),
                "api/v1/admin/user/identities/{userIdentityId}": ID.PathItem(),
            ]
        }
    }
}
