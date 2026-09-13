import FeatherAdmin
import RedirectContracts

struct RedirectRuleEditModel: Sendable {
    let id: String
    let source: String
    let destination: String
    let statusCode: StatusCode
    let notes: String?
}
