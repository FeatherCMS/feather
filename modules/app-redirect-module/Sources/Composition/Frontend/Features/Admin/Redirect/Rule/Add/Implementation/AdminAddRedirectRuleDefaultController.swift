import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import RedirectContracts

struct AdminAddRedirectRuleDefaultController: AdminAddRedirectRuleController {
    let buildRuntime: @Sendable (Request, DefaultRequestContext) -> (interactor: any AdminAddRedirectRuleInteractor, presenter: any AdminAddRedirectRulePresenter)

    func getAddRedirectRule(request: Request, context: DefaultRequestContext) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.create) else { return try await presenter.renderForbiddenPage() }
        return try await presenter.renderAddPage(state: .empty(), permissions: context.currentUserAdminListActions)
    }

    func postAddRedirectRule(request: Request, context: DefaultRequestContext) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.create) else { return try await presenter.renderForbiddenPage().response(from: request, context: context) }
        var lastPayload: RedirectRuleFormInput?
        do {
            let payload = try await request.decode(as: NonceRequest<RedirectRuleFormInput>.self, context: context)
            lastPayload = payload.input
            guard await AdminNonceStore.shared.consume(payload.nonce, sessionToken: context.sessionToken) else { return try await presenter.renderInvalidNoncePage().response(from: request, context: context) }
            try await payload.input.validate()
            try await interactor.add(input: payload.input)
            return presenter.renderSuccess()
        } catch let error as ValidationError {
            return try await presenter.renderValidationError(input: lastPayload, error: error).response(from: request, context: context)
        } catch let error as AdminAddRedirectRuleError {
            return try await presenter.renderAddError(input: lastPayload, error: error).response(from: request, context: context)
        }
    }
}
