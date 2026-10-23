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

extension SubmissionMail.Add {
    enum Presenter {}
}

extension SubmissionMail.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            formId: String,
            availableFields: [AdminContactFormFieldOption],
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
