import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormEmailsDefaultController:
    AdminListContactFormEmailsController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListContactFormEmailsInteractor,
            any AdminListContactFormEmailsPresenter
        >

    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
