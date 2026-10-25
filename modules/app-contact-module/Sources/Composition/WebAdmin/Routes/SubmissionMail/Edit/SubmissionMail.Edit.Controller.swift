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

extension SubmissionMail.Edit {
    enum Controller {}
}

extension SubmissionMail.Edit.Controller {
    protocol Interface: Sendable {
        func edit(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        func update(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
    }
}

