import FeatherAdmin
import FeatherValidation
import Hummingbird
import RedirectContracts

struct AdminEditRedirectRuleDefaultController: AdminEditRedirectRuleController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminEditRedirectRuleInteractor,
            any AdminEditRedirectRulePresenter
        >

    func getEditRedirectRule(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.update)
        else { return try await presenter.renderForbiddenPage() }
        let id = try context.requiredID()
        do {
            return try await presenter.renderEditPage(
                id: id,
                state: .from(rule: try await interactor.load(id: id)),
                permissions: context.currentUserAdminListActions
            )
        }
        catch let error as AdminEditRedirectRuleError {
            return try await presenter.renderEditError(
                id: id,
                input: nil,
                error: error
            )
        }
    }

    func postEditRedirectRule(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectPermissions.Rules.update)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        var lastPayload: RedirectRuleEditFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<RedirectRuleEditFormInput>.self,
                context: context
            )
            lastPayload = payload.input
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return try await presenter.renderInvalidNoncePage()
                    .response(from: request, context: context)
            }
            try await payload.input.validate()
            try await interactor.update(id: id, input: payload.input)
            return presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return
                try await presenter.renderValidationError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditRedirectRuleError {
            return
                try await presenter.renderEditError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
    }
}
