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
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListContactFormEmailsInteractor,
            presenter: any AdminListContactFormEmailsPresenter
        )

    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
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
