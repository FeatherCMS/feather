import Foundation

struct AdminEditAuthMagicLinkModel: Sendable {
    let id: String
    let email: String
    let isPersistent: Bool

    var payload: AuthMagicLinkFormPayloadModel {
        .init(email: email, isPersistent: isPersistent)
    }
}
