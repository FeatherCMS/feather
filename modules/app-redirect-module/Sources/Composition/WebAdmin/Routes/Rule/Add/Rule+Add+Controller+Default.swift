import FeatherWebAdmin
import FeatherValidation
import Hummingbird
import RedirectModule

extension RedirectModule.Rule.Add.Controller {
    struct Default: Interface {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any RedirectModule.Rule.Add.Interactor.Interface,
            any RedirectModule.Rule.Add.Presenter.Interface
        >

    func getAddRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let (_, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectModule.Rule.Permissions.create)
        else { return try await presenter.renderForbiddenPage() }
        return try await presenter.renderAddPage(
            state: .empty(),
            permissions: context.currentUserAdminListActions
        )
    }

    func postAddRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: RedirectModule.Rule.Permissions.create)
        else {
            return try await presenter.renderForbiddenPage()
                .response(from: request, context: context)
        }
        var lastPayload: RedirectRuleAddFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<RedirectRuleAddFormInput>.self,
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
            try await interactor.add(input: payload.input)
            return presenter.renderSuccess()
        }
        catch let error as ValidationError {
            return
                try await presenter.renderValidationError(
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
        catch let error as RedirectModule.Rule.Add.Error {
            return
                try await presenter.renderAddError(
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
    }
    }
}
