import Foundation

struct AdminEditAuthProfileModel: Sendable {
    let id: String
    let email: String
    let password: String?

    var payload: AdminEditAuthProfileFormPayloadModel {
        .init(email: email, password: password)
    }
}
