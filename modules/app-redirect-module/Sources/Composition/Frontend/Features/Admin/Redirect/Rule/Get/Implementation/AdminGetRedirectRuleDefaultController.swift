import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts

struct AdminGetRedirectRuleDefaultController: AdminGetRedirectRuleController {
    let buildRuntime: @Sendable (Request, DefaultRequestContext) -> (interactor: any AdminGetRedirectRuleInteractor, presenter: any AdminGetRedirectRulePresenter)

    func getRedirectRule(request: Request, context: DefaultRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.read) else { return try await presenter.renderErrorPage(error: .forbidden) }
        let id = try context.requiredID()
        do {
            return try await presenter.renderDetailsPage(rule: try await interactor.load(id: id), permissions: context.currentUserAdminListActions)
        } catch let error as AdminGetRedirectRuleError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
