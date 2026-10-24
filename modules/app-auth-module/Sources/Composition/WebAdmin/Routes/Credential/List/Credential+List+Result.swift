import AuthAdminAPI
import AuthModule

extension Credential.List {
    struct Result: Sendable {
        let items: [Components.Schemas.AuthCredentialQueryItemSchema]
        let total: Int
        let page: Int
        let size: Int
    }
}
