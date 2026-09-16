import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminRemoveBlogPostDefaultController:
    AdminRemoveBlogPostController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveBlogPostInteractor,
            presenter: any AdminRemoveBlogPostPresenter
        )

    func getRemoveBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            let page = try await runtime.interactor.get(id: id)
            return try await runtime.presenter.renderRemovePage(
                item: .init(id: id, label: page.title)
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
    }

    func postRemoveBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        do {
            try await runtime.interactor.delete(id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/blog/posts/",
                notification: .init(
                    title: "Removed",
                    message: "Blog post removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
