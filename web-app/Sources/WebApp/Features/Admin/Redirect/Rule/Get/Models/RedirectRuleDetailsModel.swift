import Foundation

struct RedirectRuleDetailsModel: Sendable {
    let id: String
    let source: String
    let destination: String
    let statusCode: Int
    let notes: String
}
