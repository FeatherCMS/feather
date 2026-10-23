import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared

extension Form.Add {
    enum Presenter {}
}

extension Form.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            item: ContactForm.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderAddError(
            item: ContactForm.Details.Item,
            error: Form.Add.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
