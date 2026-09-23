import FeatherAdmin
import Hummingbird
import RedirectContracts

struct AdminViewRedirectRuleDefaultController: AdminViewRedirectRuleController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminViewRedirectRuleInteractor,
            any AdminViewRedirectRulePresenter
        >

    func getRedirectRule(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.read)
        else { return try await presenter.renderErrorPage(error: .forbidden) }
        let id = try context.requiredID()
        do {
            return try await presenter.renderDetailsPage(
                rule: try await interactor.load(id: id),
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as AdminViewRedirectRuleError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
}
