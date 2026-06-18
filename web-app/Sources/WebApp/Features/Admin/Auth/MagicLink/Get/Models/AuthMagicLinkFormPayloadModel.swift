import Foundation

struct AuthMagicLinkFormPayloadModel: Sendable {
    let email: String
    let isPersistent: Bool
}
