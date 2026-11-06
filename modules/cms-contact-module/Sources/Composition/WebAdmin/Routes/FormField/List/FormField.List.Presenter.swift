import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.List {
    enum Presenter {}
}

extension FormField.List.Presenter {
    protocol Interface: Sendable {
        func renderList(
            fields: [FormField.Model],
            forms: [FormField.List.FormOption],
            total: Int,
            formKey: String?,
            search: String,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse
    }
}
