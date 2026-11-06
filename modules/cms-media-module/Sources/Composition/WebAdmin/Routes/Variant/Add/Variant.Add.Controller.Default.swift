import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Add.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Variant.Add.Interactor.Interface,
                any Variant.Add.Presenter.Interface
            >

        func getAddMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Variant.Permissions.create)
            else {
                return try await runtime.presenter.renderAddError(
                    input: nil,
                    error: .forbidden
                )
            }
            return try await runtime.presenter.renderAddPage(state: .empty())
        }

        func postAddMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Variant.Permissions.create)
            else {
                return try await runtime.presenter
                    .renderAddError(input: nil, error: .forbidden)
                    .response(from: request, context: context)
            }
            var input: Variant.Form.Input?
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Variant.Form.Input>.self,
                    context: context
                )
                input = payload.input
                guard
                    await AdminNonceStore.shared.consume(
                        payload.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    return Response(status: .badRequest)
                }
                try await payload.input.validate()
                try await runtime.interactor.add(input: payload.input)
                return runtime.presenter.renderSuccess()
            }
            catch let error as ValidationError {
                return try await runtime.presenter
                    .renderValidationError(input: input, error: error)
                    .response(from: request, context: context)
            }
            catch let error as Variant.Add.Error {
                return try await runtime.presenter
                    .renderAddError(input: input, error: error)
                    .response(from: request, context: context)
            }
        }
    }
}
