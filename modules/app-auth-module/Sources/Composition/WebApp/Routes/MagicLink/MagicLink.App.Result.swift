import AuthModule

extension MagicLink.App {
    struct Result: Sendable {
        let token: String
        let permissions: [String]
        let isPersistent: Bool
        let expiresAt: Double
    }
}
