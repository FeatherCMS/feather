import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared

extension ContactModule.Form.Edit {
    enum Presenter {}
}

extension ContactModule.Form.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            item: ContactForm.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderFieldsPage(
            item: ContactForm.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderEditError(
            key: String,
            item: ContactForm.Details.Item,
            error: ContactModule.Form.Edit.Repository.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: ContactModule.Form.Edit.Repository.Error
        ) async throws -> HTMLResponse
    }
}
