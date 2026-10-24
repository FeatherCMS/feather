import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird

extension ContactModule.Form.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any ContactModule.Form.View.Interactor.Interface,
                any ContactModule.Form.View.Presenter.Interface
            >

        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
}
