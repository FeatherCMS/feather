import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Rule.View.Interactor.Interface,
                any Rule.View.Presenter.Interface
            >

        func getRedirectRule(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: Rule.Permissions.read)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            let id = try context.requiredParameter("redirectRuleId")
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
