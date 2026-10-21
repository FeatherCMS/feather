import FeatherOpenAPI

enum Identity {}

extension Identity {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/user/identities/{userIdentityId}/sessions":
                    UserIdentitySessionPathItems(),
                "api/v1/admin/user/identities/{userIdentityId}/sessions/{sessionId}":
                    UserIdentitySessionIdPathItems(),
            ]
        }
    }
}
