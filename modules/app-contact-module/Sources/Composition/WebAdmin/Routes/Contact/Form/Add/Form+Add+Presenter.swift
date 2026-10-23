import ContactModule
import ContactWebShared
import FeatherWebAdmin

extension Form.Add {
    enum Presenter {}
}

extension Form.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            item: AdminContactFormDetailsItem,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderAddError(
            item: AdminContactFormDetailsItem,
            error: Form.Add.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
