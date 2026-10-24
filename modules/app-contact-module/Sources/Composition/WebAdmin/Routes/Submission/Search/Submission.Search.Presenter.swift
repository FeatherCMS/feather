import ContactApplication
import ContactModule
import FeatherWebAdmin

extension Submission.Search {
    enum Presenter {}
}

extension Submission.Search.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Submission.Search.Model,
            search: String,
            formKey: String?,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
