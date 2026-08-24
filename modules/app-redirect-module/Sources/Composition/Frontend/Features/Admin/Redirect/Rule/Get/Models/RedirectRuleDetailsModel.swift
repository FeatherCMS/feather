import FeatherAdmin
import Foundation
import RedirectContracts

struct RedirectRuleDetailsModel: Sendable {
    let id: String
    let source: String
    let destination: String
    let statusCode: StatusCode
    let notes: String?
}
