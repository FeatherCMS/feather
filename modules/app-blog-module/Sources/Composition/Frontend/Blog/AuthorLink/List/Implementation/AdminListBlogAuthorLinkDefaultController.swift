import BlogAdminAPI
import BlogAppAPI
import BlogContracts
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

struct AdminListBlogAuthorLinkDefaultController:
    AdminListBlogAuthorLinkController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListBlogAuthorLinkInteractor,
            any AdminListBlogAuthorLinkPresenter
        >

    func getBlogAuthorLinks(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let menuId = try context.requiredID()
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: BlogPermissions.AuthorLinks.list
        )
        let emptyModel = AdminListBlogAuthorLinkModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListBlogAuthorLinkModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listBlogAuthorLinks(
                    menuId: menuId,
                    page: page,
                    search: search
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return try await presenter.renderListPage(
            menuId: menuId,
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
    func postBlogAuthorLinksRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
        let menuId = try context.requiredID()
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let payload = nonceRequest.input
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(
                menuId: menuId,
                ids: payload.normalizedSelectedIds
            )
        }
        let location = BlogAdminRoutes.author(RouterPath(menuId)).description
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "Blog author links removed successfully."
            )
        )
    }
}
