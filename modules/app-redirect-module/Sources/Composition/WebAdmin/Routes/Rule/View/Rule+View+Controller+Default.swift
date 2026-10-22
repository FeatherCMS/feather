import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Rule.View.Interactor.Interface,
                any Rule.View.Presenter.Interface
            >

        func getRedirectRule(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let (interactor, presenter) = buildRuntime((request, context))
            guard context.isCurrentUserAllowed(to: Rule.Permissions.read)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            let id = try context.requiredID()
            do {
                return try await presenter.renderDetailsPage(
                    rule: try await interactor.load(id: id),
                    permissions: context.currentUserAdminListActions
                )
            }
            catch let error as Rule.View.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
