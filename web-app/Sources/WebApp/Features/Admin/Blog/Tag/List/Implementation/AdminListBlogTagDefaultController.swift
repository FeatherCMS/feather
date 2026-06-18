import Hummingbird

struct AdminListBlogTagDefaultController:
    AdminListBlogTagController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListBlogTagInteractor,
            presenter: any AdminListBlogTagPresenter
        )

    func getBlogTags(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminBlog.Scope.tags
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

    func getBlogTagsBulkRemoveConfirmation(
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
                        path: "/admin/blog/tags/",
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

    func postBlogTagsBulkRemove(
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
                    path: "/admin/blog/tags/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Blog tag removed successfully." : nil
                )
            ]
        )
    }

    func postBlogTagStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogTagFormOpenAPIRepository(
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
                    defaultPath: "/admin/blog/tags/",
                    returnTo: payload.normalizedReturnTo,
                    title: toast.title,
                    message: toast.message
                )
            ]
        )
    }

    private func makeFormInput(
        from details: BlogTagDetailsModel
    ) -> BlogTagFormInput {
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
