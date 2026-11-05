import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List {
    enum Controller {}
}

extension SubmissionMail.List.Controller {
    protocol Interface: Sendable {
        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
    }
}
