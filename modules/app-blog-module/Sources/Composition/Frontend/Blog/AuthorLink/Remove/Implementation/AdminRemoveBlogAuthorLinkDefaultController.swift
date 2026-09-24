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

struct AdminRemoveBlogAuthorLinkDefaultController:
    AdminRemoveBlogAuthorLinkController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveBlogAuthorLinkInteractor,
            any AdminRemoveBlogAuthorLinkPresenter
        >

    func getRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime((request, context))
        let menuId = try request.requiredID()
        let id = try request.requiredParameter("itemId")
        do {
            let rule = try await runtime.interactor.get(menuId: menuId, id: id)
            return try await runtime.presenter.renderRemovePage(
                menuId: menuId,
                item: .init(id: id, label: rule.label)
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                menuId: menuId,
                id: id,
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
    }

    func postRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let menuId = try request.requiredID()
        let id = try request.requiredParameter("itemId")
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
            try await runtime.interactor.delete(menuId: menuId, id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/blog/authors/\(menuId)/",
                notification: .init(
                    title: "Removed",
                    message: "Link removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    menuId: menuId,
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
