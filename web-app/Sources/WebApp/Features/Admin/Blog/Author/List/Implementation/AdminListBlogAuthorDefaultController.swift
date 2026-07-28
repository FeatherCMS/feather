import Hummingbird

struct AdminListBlogAuthorDefaultController:
    AdminListBlogAuthorController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListBlogAuthorInteractor,
            presenter: any AdminListBlogAuthorPresenter
        )

    func getBlogAuthors(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminBlog.Scope.authors
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

    func getBlogAuthorsBulkRemoveConfirmation(
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
                        path: "/admin/blog/authors/",
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

    func postBlogAuthorsBulkRemove(
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
                    path: "/admin/blog/authors/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Blog author removed successfully." : nil
                )
            ]
        )
    }

    func postBlogAuthorStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListBlogAuthorFormOpenAPIRepository(
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
                    defaultPath: "/admin/blog/authors/",
                    returnTo: payload.normalizedReturnTo,
                    title: toast.title,
                    message: toast.message
                )
            ]
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
            metadataSlug: details.metadata.slug,
            metadataPublicationDate: details.metadata.publicationDate,
            metadataExpirationDate: details.metadata.expirationDate,
            metadataStatus: details.metadata.status,
            metadataTitle: details.metadata.title,
            metadataExcerpt: details.metadata.excerpt,
            metadataImageUrl: details.metadata.imageUrl,
            metadataCanonicalUrl: details.metadata.canonicalUrl,
            metadataNoIndex: .init(value: details.metadata.noIndex),
            metadataPrimaryKeyword: details.metadata.primaryKeyword,
            metadataCSSCodeInjection: details.metadata.cssCodeInjection,
            metadataJavaScriptCodeInjection: details.metadata
                .javascriptCodeInjection,
            metadataStructuredDataCodeInjection: details.metadata
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
            return ("Published", "Blog author published successfully.")
        case "archived":
            return ("Archived", "Blog author archived successfully.")
        default:
            return ("Draft", "Blog author moved to draft successfully.")
        }
    }
}
