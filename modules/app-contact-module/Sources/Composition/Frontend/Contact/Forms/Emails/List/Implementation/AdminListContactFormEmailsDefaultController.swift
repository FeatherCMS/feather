import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormEmailsDefaultController:
    AdminListContactFormEmailsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListContactFormEmailsInteractor,
            presenter: any AdminListContactFormEmailsPresenter
        )

    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        do {
            return presenter.renderPage(
                item: try await interactor.get(id: formId),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                item: .init(
                    id: formId,
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
