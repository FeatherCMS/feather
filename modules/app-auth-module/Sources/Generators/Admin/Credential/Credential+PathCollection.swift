import FeatherOpenAPI

enum Credential {}

extension Credential {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/auth/credentials": AuthCredentialPathItems(),
                "api/v1/admin/auth/credentials/": AuthCredentialListPathItems(),
                "api/v1/admin/auth/credentials/search":
                    AuthCredentialSearchPathItems(),
                "api/v1/admin/auth/credentials/{authCredentialId}":
                    AuthCredentialIdPathItems(),
            ]
        }
    }
}
