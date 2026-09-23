import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactFormDefaultController: AdminViewContactFormController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewContactFormInteractor,
            any AdminViewContactFormPresenter
        >

    func get(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let formId = try context.requiredParameter("formId")
        do {
            return try await presenter.renderDetailsPage(
                item: try await interactor.get(id: formId),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderDetailsPage(
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
