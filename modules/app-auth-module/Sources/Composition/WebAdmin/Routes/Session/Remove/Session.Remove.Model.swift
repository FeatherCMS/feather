import AuthModule
import FeatherWebAdmin

extension Session.Remove {
    struct Model: Sendable {
        let identityId: String
        let sessionId: String
        let identityEmail: String
        let isPersistent: Bool
        let expiresAt: Double
        let createdAt: Double
        let updatedAt: Double
    }
}
