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
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
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
