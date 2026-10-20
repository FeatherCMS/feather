import UserModule

extension Identity.Detail {
    struct RepositoryModel: Sendable {
        let id: String
        let name: String
        let status: String
        let roleIds: [String]
    }
}
