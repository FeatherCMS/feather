import UserModule

extension Identity.Detail.Repository {
    struct Model: Sendable {
        let id: String
        let name: String
        let status: String
        let roleIds: [String]
    }
}
