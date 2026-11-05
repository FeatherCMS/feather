import UserModule

extension Identity.Add {
    struct FormPayload: Sendable {
        let name: String
        let status: String
        let roleIds: [String]
    }
}
