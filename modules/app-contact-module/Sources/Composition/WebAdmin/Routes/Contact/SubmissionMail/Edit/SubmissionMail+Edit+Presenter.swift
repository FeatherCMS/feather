import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Edit {
    enum Presenter {}
}

extension SubmissionMail.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            formId: String,
            mail: AdminContactFormEmail,
            availableFields: [AdminContactFormFieldOption],
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
