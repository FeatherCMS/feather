import FeatherAdmin
import Hummingbird
import FeatherContracts
import RedirectContracts

struct AdminListRedirectRuleDefaultController: AdminListRedirectRuleController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListRedirectRuleInteractor,
            presenter: any AdminListRedirectRulePresenter
        )

    func getRedirectRules(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.list)
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
        }

        let search = request.querySearch()
        let rawStatusCode = request.queryString("statusCode")?
            .whitespaceTrimmed
        let statusCode = rawStatusCode.flatMap(Int.init)
            .flatMap(StatusCode.init(rawValue:))
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
        catch let error as AdminListRedirectRuleError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
