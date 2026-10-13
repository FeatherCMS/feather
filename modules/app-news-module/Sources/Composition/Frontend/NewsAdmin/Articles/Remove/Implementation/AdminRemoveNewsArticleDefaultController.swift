import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminRemoveNewsArticleDefaultController: AdminRemoveNewsArticleController
{
    let buildRuntime: AdminNewsArticleRuntimeBuilder

    func getRemoveNewsArticleConfirmation(
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
                .renderError(error.displayMessage)
                .response(from: request, context: context)
        }
    }

    func postRemoveNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: NonceRequest<NewsAdminRemoveInput>.self,
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
