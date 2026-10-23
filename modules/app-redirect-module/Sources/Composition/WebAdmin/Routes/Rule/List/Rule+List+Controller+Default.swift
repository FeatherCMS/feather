import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Rule.List.Interactor.Interface,
                any Rule.List.Presenter.Interface
            >

        func getRedirectRules(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            guard context.isCurrentUserAllowed(to: Rule.Permissions.list)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }

            let search = request.querySearch()
            let rawStatusCode = request.queryString("statusCode")?
                .whitespaceTrimmed
            let statusCode = rawStatusCode.flatMap(Int.init)
                .flatMap(Rule.StatusCode.init(rawValue:))
            do {
                let model = try await interactor.listRedirectRules(
                    page: request.queryPage(),
                    search: search,
                    statusCode: statusCode
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: context.currentUserAdminListActions,
                    search: search,
                    statusCode: rawStatusCode
                )
            }
            catch let error as Rule.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
