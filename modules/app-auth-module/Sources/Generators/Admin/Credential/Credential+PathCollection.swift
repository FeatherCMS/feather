import FeatherOpenAPI

extension Credential {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/credentials": Credential.PathItem(),
                "api/v1/admin/auth/credentials/query":
                    Credential.Query.PathItem(),
                "api/v1/admin/auth/credentials/{authCredentialId}":
                    Credential.ID.PathItem(),
            ]
        }
    }
}
