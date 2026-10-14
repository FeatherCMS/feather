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

struct AdminListBlogTagDefaultController:
    AdminListBlogTagController
{
    let apiBuilder: BlogAPIBuilder
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListBlogTagInteractor,
            any AdminListBlogTagPresenter
        >

    func getBlogTags(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: BlogPermissions.Tags.list
        )
        let emptyModel = AdminListBlogTagModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListBlogTagModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listBlogTags(
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
    func postBlogTagStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogTagFormOpenAPIRepository(
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
            referenceType: "blog.tag",
            referenceID: id,
            status: targetStatus
        )
        let toast = statusToastContent(for: targetStatus)
        return AdminNotificationFlash.redirect(
            to: payload.normalizedReturnTo ?? BlogAdminRoutes.tags.description
                + "/",
            notification: .init(title: toast.title, message: toast.message)
        )
    }

    private func makeFormInput(
        from details: BlogTagDetailsModel
    ) -> BlogTagFormInput {
        .init(
            title: details.title,
            excerpt: details.excerpt,
            content: details.content,
            imageAssetId: details.imageAsset?.id,
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
            return ("Published", "Blog tag published successfully.")
        case "archived":
            return ("Archived", "Blog tag archived successfully.")
        default:
            return ("Draft", "Blog tag moved to draft successfully.")
        }
    }
}
