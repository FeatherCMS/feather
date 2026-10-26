import FeatherOpenAPI

extension Identity {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/user/identities/{userIdentityId}/sessions":
                    Session.PathItem(),
                "api/v1/admin/user/identities/{userIdentityId}/sessions/query":
                    Session.Query.PathItem(),
            ]
        }
    }
}
