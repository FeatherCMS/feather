import FeatherValidation
import HTML
import Hummingbird

struct AdminEditBlogPostDefaultController:
    AdminEditBlogPostController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditBlogPostInteractor,
            presenter: any AdminEditBlogPostPresenter
        )

    func getEditBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let page = try await runtime.interactor.load(id: id)
            let options =
                (try? await runtime.interactor.loadOptions())
                ?? .init(authors: [], tags: [])
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    title: page.title,
                    excerpt: page.excerpt,
                    content: page.content,
                    imageAssetId: page.imageAssetId,
                    imageAsset: page.imageAsset,
                    metadata: page.metadata,
                    selectedAuthorIds: page.authorIds,
                    selectedTagIds: page.tagIds,
                    options: options
                ),
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: BlogPostFormInput?

        do {
            let payload = try await request.decode(
                as: BlogPostFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/blog/posts/\(id)/edit/",
                        title: "Saved",
                        message: "Post edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                options: (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: [])
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                options: (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: [])
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                options: (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: [])
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        title: String = "",
        excerpt: String = "",
        content: String = "",
        imageAssetId: String? = nil,
        imageAsset: AdminMediaAssetReferenceModel? = nil,
        metadata: AdminMetadataFormValue? = nil,
        selectedAuthorIds: [String] = [],
        selectedTagIds: [String] = [],
        options: BlogPostAssociationOptionsModel
    ) -> BlogPostForm.State {
        .init(
            title: .init(
                key: "title",
                label: "Title",
                value: title,
                error: nil
            ),
            excerpt: .init(
                key: "excerpt",
                label: "Excerpt",
                value: excerpt,
                error: nil
            ),
            content: .init(
                key: "content",
                label: "Content",
                value: content,
                error: nil
            ),
            imageAssetId: .init(
                key: "imageAssetId",
                label: "Featured image",
                value: imageAssetId,
                error: nil
            ),
            selectedImageAsset: imageAsset,
            metadata: AdminMetadataFieldStateFactory.make(metadata),
            authorOptions: optionStates(
                key: "authorIds[]",
                selectedIDs: selectedAuthorIds,
                options: options.authors
            ),
            tagOptions: optionStates(
                key: "tagIds[]",
                selectedIDs: selectedTagIds,
                options: options.tags
            ),
            authorIdsError: nil,
            tagIdsError: nil,
            error: nil,
            success: nil
        )
    }

    private func optionStates(
        key: String,
        selectedIDs: [String],
        options: [BlogPostAssociationOptionModel]
    ) -> [BlogPostForm.OptionState] {
        let selectedSet = Set(selectedIDs)
        let normalizedOptions = mergeMissingSelections(
            selectedIDs: selectedIDs,
            into: options
        )
        return normalizedOptions.map {
            .init(
                key: key,
                label: $0.label,
                value: $0.id,
                isSelected: selectedSet.contains($0.id)
            )
        }
    }

    private func mergeMissingSelections(
        selectedIDs: [String],
        into options: [BlogPostAssociationOptionModel]
    ) -> [BlogPostAssociationOptionModel] {
        let knownIDs = Set(options.map(\.id))
        let missing =
            selectedIDs
            .filter { !knownIDs.contains($0) }
            .map { BlogPostAssociationOptionModel(id: $0, label: $0) }
        return options + missing
    }
}
