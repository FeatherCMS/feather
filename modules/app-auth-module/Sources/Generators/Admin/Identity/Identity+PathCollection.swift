import FeatherOpenAPI

extension Identity {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/user/identities/{userIdentityId}/sessions":
                    UserIdentitySessionPathItems()
            ]
        }
    }
}
