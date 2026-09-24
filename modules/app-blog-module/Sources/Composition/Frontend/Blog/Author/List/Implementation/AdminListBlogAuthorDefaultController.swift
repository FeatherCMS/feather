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

    func getBlogAuthorsRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime((request, context))
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.url(
                        path: BlogAdminRoutes.authors.description + "/",
                        page: page,
                        search: search
                    )
                ]
            )
        }
        return
            try await presenter.renderRemovePage(
                page: page,
                search: search,
                items: selectedIds.map { .init(id: $0, label: $0) }
            )
            .response(from: request, context: context)
    }

    func postBlogAuthorsRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
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
        let payload = nonceRequest.input
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = NewAdminLocation.url(
            path: BlogAdminRoutes.authors.description + "/",
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
                message: "Blog authors removed successfully."
            )
        )
    }

    func postBlogAuthorStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: NewAdminStatusActionFormInput.self,
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
            return ("Published", "Blog author published successfully.")
        case "archived":
            return ("Archived", "Blog author archived successfully.")
        default:
            return ("Draft", "Blog author moved to draft successfully.")
        }
    }
}
