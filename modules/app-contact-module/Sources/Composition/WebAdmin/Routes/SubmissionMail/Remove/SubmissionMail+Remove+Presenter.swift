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

extension SubmissionMail.Remove {
    enum Presenter {}
}

extension SubmissionMail.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            formId: String,
            items: [AdminRemoveItemContext]
        ) async throws -> HTMLResponse
    }
}
