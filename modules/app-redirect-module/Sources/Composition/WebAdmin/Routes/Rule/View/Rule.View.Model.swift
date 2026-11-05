import RedirectDomain
import RedirectModule

extension Rule.View {
    struct Model: Sendable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Rule.Model.StatusCode
        let notes: String?
    }
}
