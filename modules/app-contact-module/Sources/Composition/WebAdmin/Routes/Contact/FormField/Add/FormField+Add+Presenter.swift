import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension FormField.Add {
    enum Presenter {}
}

extension FormField.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: FormField.Add.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderAddError(
            input: ContactFieldFormInput,
            error: FormField.Add.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse
    }
}
