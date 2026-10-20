import FeatherWebAdmin
import FeatherModuleKit
import Hummingbird

struct AdminRemoveNewsArticleDefaultController: AdminRemoveNewsArticleController
{
    let buildRuntime: AdminNewsArticleRuntimeBuilder

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
