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
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewContactFormInteractor,
            presenter: any AdminViewContactFormPresenter
        )

    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formKey = try context.requiredParameter("formKey")
        do {
            return try await presenter.renderDetailsPage(
                item: try await interactor.get(key: formKey),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderDetailsPage(
                item: .init(
                    key: formKey,
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
