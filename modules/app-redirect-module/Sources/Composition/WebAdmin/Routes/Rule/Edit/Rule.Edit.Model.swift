import RedirectApplication
import RedirectModule

extension Rule.Edit {
    struct Model: Sendable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Rule.StatusCode
        let notes: String?
    }
}
