import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List {
    enum Presenter {}
}

extension SubmissionMail.List.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            item: AdminContactFormDetailsItem,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
