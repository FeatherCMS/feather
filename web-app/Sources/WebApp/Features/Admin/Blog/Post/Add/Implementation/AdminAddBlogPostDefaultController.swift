import FeatherValidation
import Foundation
import HTML
import Hummingbird

struct AdminAddBlogPostDefaultController: AdminAddBlogPostController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddBlogPostInteractor,
            presenter: any AdminAddBlogPostPresenter
        )

    func getAddBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
        let options =
            (try? await runtime.interactor.loadOptions())
            ?? .init(authors: [], tags: [])
        return runtime.presenter.renderAddPage(
            state: formState(options: options, slugPrefix: slugPrefix),
            permissions: context.currentUserPermissions
        )
    }

    func postAddBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: BlogPostFormInput?

        do {
            let payload = try await request.decode(
                as: BlogPostFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/blog/posts/",
                        title: "Added",
                        message: "Blog post added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
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
                    ?? .init(authors: [], tags: []),
                slugPrefix: slugPrefix
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                options: (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: []),
                slugPrefix: slugPrefix
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                options: (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: []),
                slugPrefix: slugPrefix
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderAddPage(
                    state: state,
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
        metadata: AdminMetadataFormValue? = nil,
        selectedAuthorIds: [String] = [],
        selectedTagIds: [String] = [],
        options: BlogPostAssociationOptionsModel,
        slugPrefix: String? = nil
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
            selectedImageAsset: nil,
            metadata: AdminMetadataFieldStateFactory.make(
                metadata,
                slugPrefix: slugPrefix
            ),
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

    private func slugPrefix(
        context: AppRequestContext
    ) async throws -> String {
        try await slugPrefix(
            context: context,
            keyPath: \.postPathPrefix
        )
    }

    private func slugPrefix(
        context: AppRequestContext,
        keyPath: KeyPath<AppPublicBlogRouteSettings, String>
    ) async throws -> String {
        let schema = try await AppPublicContentOpenAPIRepository(
            api: context.applicationAPI()
        )
        .getRouteSettings()
        let settings = AppPublicBlogRouteSettings(schema: schema)
        let prefix = settings[keyPath: keyPath]
        return prefix.isEmpty ? "/" : "/\(prefix)/"
    }
}
