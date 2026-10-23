import ContactApplication
import ContactModule
import FeatherWebAdmin

extension Submission.Edit {
    enum Presenter {}
}

extension Submission.Edit.Presenter {
    protocol Interface: Sendable {
        func renderError(
            formId: String,
            id: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
