import FeatherOpenAPI

extension Credential {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/credentials": PathItem(),
                "api/v1/admin/auth/credentials/query":
                    Query.PathItem(),
                "api/v1/admin/auth/credentials/{authCredentialId}":
                    ID.PathItem(),
            ]
        }
    }
}
