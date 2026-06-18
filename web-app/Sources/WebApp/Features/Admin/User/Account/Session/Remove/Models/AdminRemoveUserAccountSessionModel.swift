import Foundation

struct AdminRemoveUserAccountSessionModel: Sendable {
    let accountId: String
    let sessionId: String
    let accountEmail: String
    let isPersistent: Bool
    let expiresAt: Double
    let createdAt: Double
    let updatedAt: Double
}
