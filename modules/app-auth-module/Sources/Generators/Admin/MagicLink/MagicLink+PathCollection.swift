import FeatherOpenAPI

extension MagicLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/magic-links":
                    PathItem(),
                "api/v1/admin/auth/magic-links/query":
                    Query.PathItem(),
                "api/v1/admin/auth/magic-links/{authMagicLinkId}":
                    ID.PathItem(),
            ]
        }
    }
}
