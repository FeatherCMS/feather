import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Post.Edit.Controller {
    struct Default: Interface {
        let routes: Post.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Post.Edit.Interactor.Interface,
                any Post.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            do {
                let page = try await runtime.interactor.load(id: id)
                let options =
                    (try? await runtime.interactor.loadOptions())
                    ?? .init(authors: [], tags: [])
                return try await runtime.presenter.render(
                    id: id,
                    state: formState(
                        title: page.title,
                        excerpt: page.excerpt,
                        content: page.content,
                        imageAssetId: page.imageAsset?.id,
                        imageAsset: page.imageAsset,
                        metadata: page.metadata,
                        selectedAuthorIds: page.authorIds,
                        selectedTagIds: page.tagIds,
                        options: options
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderError(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            var lastPayload: Post.Form.Input?

            do {
                let payload = try await request.decode(
                    as: Post.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.update(id: id, input: payload)

                return AdminNotificationFlash.redirect(
                    to: routes.postEditPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Post edited successfully."
                    )
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
                    selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                    selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                    options: (try? await runtime.interactor.loadOptions())
                        ?? .init(authors: [], tags: [])
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .render(
                        id: id,
                        state: state,
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
                    selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                    selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                    options: (try? await runtime.interactor.loadOptions())
                        ?? .init(authors: [], tags: [])
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .render(
                        id: id,
                        state: state,
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
                    selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                    selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                    options: (try? await runtime.interactor.loadOptions())
                        ?? .init(authors: [], tags: [])
                )
                state.error = error.displayMessage
                return try await runtime.presenter
                    .render(
                        id: id,
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
            imageAsset: AdminMediaAsset? = nil,
            metadata: AdminMetadataFormValue? = nil,
            selectedAuthorIds: [String] = [],
            selectedTagIds: [String] = [],
            options: Post.Association.Options
        ) -> Post.Form.State {
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
                metadata: WebModule.Metadata.FieldStateFactory.make(metadata),
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
            )
        }

        private func optionStates(
            key: String,
            selectedIDs: [String],
            options: [Post.Association.Option]
        ) -> [Post.Form.OptionState] {
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
            into options: [Post.Association.Option]
        ) -> [Post.Association.Option] {
            let knownIDs = Set(options.map(\.id))
            let missing =
                selectedIDs
                .filter { !knownIDs.contains($0) }
                .map { Post.Association.Option(id: $0, label: $0) }
            return options + missing
        }
    }
}
