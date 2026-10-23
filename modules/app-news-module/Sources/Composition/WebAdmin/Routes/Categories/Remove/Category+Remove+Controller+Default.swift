import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Remove.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) ->
                WebAdminRuntime<
                    any Category.Remove.Interactor.Interface,
                    any Category.Remove.Presenter.Interface
                >

        func getRemoveNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            do {
                let item = try await runtime.interactor.get(
                    id: context.requiredID()
                )
                return try await runtime.presenter.renderRemoveConfirmation(
                    item: item
                )
            }
            catch {
                return try await runtime.presenter
                    .renderError(
                        error.displayMessage
                    )
                    .response(from: request, context: context)
            }
        }

        func postRemoveNewsCategory(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let payload = try await request.decode(
                as: NonceRequest<RemoveInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return Response(status: .badRequest)
            }
            try await runtime.interactor.remove(id: id)
            return runtime.presenter.renderRemoved()
        }
    }
}
