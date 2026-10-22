import RedirectModule

struct RedirectRuleDetailsModel: Sendable {
    let id: String
    let source: String
    let destination: String
    let statusCode: Rule.StatusCode
    let notes: String?
}
