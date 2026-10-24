import AuthAdminAPI
import AuthModule

extension Email.List {
    struct Result: Sendable {
        let items: [Components.Schemas.AuthEmailQuerySchemasItem]
        let identityNames: [String: String]
        let total: Int
        let page: Int
        let size: Int
    }
}
