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

extension SubmissionMail.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any SubmissionMail.List.Interactor.Interface,
                any SubmissionMail.List.Presenter.Interface
            >

        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let formId = try context.requiredParameter("formKey")
            do {
                return try await presenter.renderPage(
                    item: try await interactor.get(id: formId),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch {
                return try await presenter.renderPage(
                    item: .init(
                        key: formId,
                        name: "",
                        successMessage: "",
                        failureMessage: "",
                        submitLabel: "Submit",
                        redirectUrl: nil,
                        selectedFieldIDs: [],
                        availableFields: [],
                        mails: []
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
            }
        }
    }
}
