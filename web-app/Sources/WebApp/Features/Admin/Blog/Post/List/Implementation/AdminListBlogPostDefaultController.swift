import Hummingbird

struct AdminListBlogPostDefaultController:
    AdminListBlogPostController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListBlogPostInteractor,
            presenter: any AdminListBlogPostPresenter
        )

    func getBlogPosts(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminBlog.Scope.posts
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
        return presenter.renderListPage(
            model: model,
            isAdded: request.hasQueryFlag("added"),
            isEdited: request.hasQueryFlag("edited"),
            isRemoved: request.hasQueryFlag("removed"),
            isPublished: request.hasQueryFlag("published"),
            isUnpublished: request.hasQueryFlag("unpublished"),
            permissions: permissions,
            search: search,
            error: error
        )
    }

    func getBlogPostsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListBulkRemoveRedirect.location(
                        path: "/admin/blog/posts/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return
            try presenter.renderBulkRemoveConfirmation(
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postBlogPostsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/blog/posts/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Blog post removed successfully." : nil
                )
            ]
        )
    }

    func postBlogPostStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogPostFormOpenAPIRepository(
            api: context.managementAPI()
        )
        let details = try await repository.load(id: id)
        let targetStatus = resolvedStatus(
            from: payload,
            current: details.metadata
        )
        let input = makeFormInput(from: details)
            .withStatus(targetStatus)
        try await repository.update(id: id, input: input)
        let toast = statusToastContent(for: targetStatus)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminStatusActionRedirect.location(
                    defaultPath: "/admin/blog/posts/",
                    returnTo: payload.normalizedReturnTo,
                    title: toast.title,
                    message: toast.message
                )
            ]
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
            slug: details.metadata.slug,
            publicationDate: details.metadata.publicationDate,
            expirationDate: details.metadata.expirationDate,
            status: details.metadata.status,
            metadataTitle: details.metadata.title,
            metadataExcerpt: details.metadata.excerpt,
            imageUrl: details.metadata.imageUrl,
            canonicalUrl: details.metadata.canonicalUrl,
            noIndex: .init(value: details.metadata.noIndex),
            primaryKeyword: details.metadata.primaryKeyword,
            cssCodeInjection: details.metadata.cssCodeInjection,
            javascriptCodeInjection: details.metadata.javascriptCodeInjection,
            structuredDataCodeInjection: details.metadata
                .structuredDataCodeInjection,
            authorIds: details.authorIds,
            tagIds: details.tagIds,
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
            return ("Published", "Blog post published successfully.")
        case "archived":
            return ("Archived", "Blog post archived successfully.")
        default:
            return ("Draft", "Blog post moved to draft successfully.")
        }
    }
}
