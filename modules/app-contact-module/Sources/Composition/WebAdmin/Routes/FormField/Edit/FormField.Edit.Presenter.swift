import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit {
    enum Presenter {}
}

extension FormField.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            field: FormField.Model,
            error: String?,
            fieldErrors: [String: String],
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderEditError(
            field: FormField.Model,
            error: FormField.Edit.Interactor.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: FormField.Edit.Interactor.Error
        ) async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse
    }
}
