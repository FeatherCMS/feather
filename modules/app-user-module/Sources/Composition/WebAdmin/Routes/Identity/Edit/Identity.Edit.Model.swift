import UserModule

extension Identity.Edit {
    struct Model: Sendable {
        let id: String
        let name: String
        let status: String
        let roleIds: [String]

    }
}
