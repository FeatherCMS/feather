import BlogAdminAPI
import FeatherWebShared
import BlogAppAPI
import BlogContracts
import FeatherWebAdmin
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
}
