import UserModule

extension Identity.Edit {
    struct FormPayload: Sendable {
        let name: String
        let status: String
        let roleIds: [String]
    }
}
