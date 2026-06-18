import Foundation

struct AdminAddAuthMagicLinkModel: Sendable {
    let email: String
    let isPersistent: Bool

    var payload: AuthMagicLinkFormPayloadModel {
        .init(email: email, isPersistent: isPersistent)
    }
}
