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

struct AdminListBlogPostDefaultController:
    AdminListBlogPostController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListBlogPostInteractor,
            presenter: any AdminListBlogPostPresenter
        )

    func getBlogPosts(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: BlogPermissions.Posts.list
        )
        let emptyModel = AdminListBlogPostModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListBlogPostModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listBlogPosts(
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

    func getBlogPostsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.url(
                        path: BlogAdminRoutes.posts.description + "/",
                        page: page,
                        search: search
                    )
                ]
            )
        }
        return
            try await presenter.renderRemoveConfirmation(
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postBlogPostsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = NewAdminLocation.url(
            path: BlogAdminRoutes.posts.description + "/",
            page: payload.normalizedPage,
            search: payload.normalizedSearch
        )
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "Blog posts removed successfully."
            )
        )
    }

    func postBlogPostStatus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: NewAdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogPostFormOpenAPIRepository(
            api: context.blogAdminAPI()
        )
        let details = try await repository.load(id: id)
        let targetStatus = resolvedStatus(
            from: payload,
            current: details.metadata
        )
        try await AdminWebMetadataStatusUpdater(
            api: context.webAdminAPI()
        )
        .update(
            referenceType: "blog.post",
            referenceID: id,
            status: targetStatus
        )
        let toast = statusToastContent(for: targetStatus)
        return AdminNotificationFlash.redirect(
            to: payload.normalizedReturnTo ?? BlogAdminRoutes.posts.description
                + "/",
            notification: .init(title: toast.title, message: toast.message)
        )
    }

    private func makeFormInput(
        from details: BlogPostDetailsModel
    ) -> BlogPostFormInput {
        .init(
            title: details.title,
            excerpt: details.excerpt,
            content: details.content,
            imageAssetId: details.imageAssetId,
            authorIds: details.authorIds,
            tagIds: details.tagIds,
            submitAction: nil
        )
    }

    private func resolvedStatus(
        from payload: NewAdminStatusActionFormInput,
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
            return ("Published", "Blog post published successfully.")
        case "archived":
            return ("Archived", "Blog post archived successfully.")
        default:
            return ("Draft", "Blog post moved to draft successfully.")
        }
    }
}
