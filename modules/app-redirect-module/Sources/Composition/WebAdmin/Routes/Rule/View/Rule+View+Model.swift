import RedirectModule

extension Rule.View {
    struct Model: Sendable {
        let id: String
        let source: String
        let destination: String
        let statusCode: Rule.StatusCode
        let notes: String?
    }
}
