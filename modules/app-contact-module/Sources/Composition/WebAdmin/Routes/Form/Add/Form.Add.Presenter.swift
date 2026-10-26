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
            item: ContactModule.Form.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderAddError(
            item: ContactModule.Form.Details.Item,
            error: Form.Add.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
