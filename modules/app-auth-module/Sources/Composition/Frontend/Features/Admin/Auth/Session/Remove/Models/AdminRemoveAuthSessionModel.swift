import FeatherAdmin
import Foundation

struct AdminRemoveAuthSessionModel: Sendable {
    let identityId: String
    let sessionId: String
    let identityEmail: String
    let isPersistent: Bool
    let expiresAt: Double
    let createdAt: Double
    let updatedAt: Double
}
