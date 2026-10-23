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

extension SubmissionMail.Edit {
    enum Presenter {}
}

extension SubmissionMail.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            formId: String,
            mail: ContactForm.Email,
            availableFields: [ContactForm.Field.Option],
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
