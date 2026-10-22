import FeatherOpenAPI

extension MagicLink {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/magic-links":
                    MagicLink.PathItem(),
                "api/v1/admin/auth/magic-links/query":
                    MagicLink.Query.PathItem(),
                "api/v1/admin/auth/magic-links/{authMagicLinkId}":
                    MagicLink.ID.PathItem(),
            ]
        }
    }
}
