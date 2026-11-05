import ContactApplication
import ContactModule
import FeatherWebAdmin

extension Submission.Detail {
    enum Presenter {}
}

extension Submission.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            formId: String,
            item: Submission.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
