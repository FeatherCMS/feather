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

struct AdminListBlogAuthorDefaultController:
    AdminListBlogAuthorController
{
    let apiBuilder: BlogAPIBuilder
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListBlogAuthorInteractor,
            any AdminListBlogAuthorPresenter
        >

    func getBlogAuthors(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: BlogPermissions.Authors.list
        )
        let emptyModel = AdminListBlogAuthorModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListBlogAuthorModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listBlogAuthors(
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
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
    func postBlogAuthorStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogAuthorFormOpenAPIRepository(
            api: apiBuilder.makeBlogAdmin(context)
        )
        let details = try await repository.load(id: id)
        let targetStatus = resolvedStatus(
            from: payload,
            current: details.metadata
        )
        try await AdminWebMetadataStatusUpdater(
            api: apiBuilder.makeWebAdmin(context)
        )
        .update(
            referenceType: "blog.author",
            referenceID: id,
            status: targetStatus
        )
        let toast = statusToastContent(for: targetStatus)
        return AdminNotificationFlash.redirect(
            to: payload.normalizedReturnTo ?? BlogAdminRoutes.authors
                .description + "/",
            notification: .init(title: toast.title, message: toast.message)
        )
    }

    private func makeFormInput(
        from details: BlogAuthorDetailsModel
    ) -> BlogAuthorFormInput {
        .init(
            name: details.name,
            excerpt: details.excerpt,
            content: details.content,
            profileImageAssetId: details.profileImageAssetId,
            submitAction: nil
        )
    }

    private func resolvedStatus(
        from payload: AdminStatusActionFormInput,
        current metadata: AdminMetadataFormValue
    ) -> String {
        let allowedStatuses = Set(["draft", "published", "archived"])
        let selectedStatus = payload.normalizedStatus
        return allowedStatuses.contains(selectedStatus)
            ? selectedStatus
            : metadata.normalizedStatus
    }

    private func statusToastContent(
        for status: String
    ) -> (title: String, message: String) {
        switch status {
        case "published":
            return ("Published", "Blog author published successfully.")
        case "archived":
            return ("Archived", "Blog author archived successfully.")
        default:
            return ("Draft", "Blog author moved to draft successfully.")
        }
    }
}
