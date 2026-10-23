import BlogAdminAPI
import BlogAppAPI
import BlogModule
import BlogWebShared
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

extension Post.Add.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Post.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Post.Add.Interactor.Interface,
                any Post.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            let options =
                (try? await runtime.interactor.loadOptions())
                ?? .init(authors: [], tags: [])
            return try await runtime.presenter.render(
                state: formState(options: options, slugPrefix: slugPrefix),
                permissions: context.currentUserPermissions
            )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            var lastPayload: Post.Form.Input?

            do {
                let payload = try await request.decode(
                    as: Post.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.execute(input: payload)

                return AdminNotificationFlash.redirect(
                    to: routes.posts.path,
                    notification: .init(
                        title: "Added",
                        message: "Blog post added successfully."
                    )
                )
            }
            catch let error as ValidationError {
                let slugPrefix =
                    (try? await slugPrefix(context: context)) ?? "/"
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
                        ?? .init(authors: [], tags: []),
                    slugPrefix: slugPrefix
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .render(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                let slugPrefix =
                    (try? await slugPrefix(context: context)) ?? "/"
                var state = formState(
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                    selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                    options: (try? await runtime.interactor.loadOptions())
                        ?? .init(authors: [], tags: []),
                    slugPrefix: slugPrefix
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .render(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                let slugPrefix =
                    (try? await slugPrefix(context: context)) ?? "/"
                var state = formState(
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    selectedAuthorIds: lastPayload?.normalizedAuthorIds ?? [],
                    selectedTagIds: lastPayload?.normalizedTagIds ?? [],
                    options: (try? await runtime.interactor.loadOptions())
                        ?? .init(authors: [], tags: []),
                    slugPrefix: slugPrefix
                )
                state.error = error.displayMessage
                return try await runtime.presenter
                    .render(
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
            options: Post.Association.Options,
            slugPrefix: String? = nil
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
                selectedImageAsset: nil,
                metadata: WebModule.Metadata.FieldStateFactory.make(
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

        private func slugPrefix(
            context: AuthenticatedRequestContext
        ) async throws -> String {
            try await slugPrefix(
                context: context,
                keyPath: \.postPathPrefix
            )
        }

        private func slugPrefix(
            context: AuthenticatedRequestContext,
            keyPath: KeyPath<Settings.PublicRoutes, String>
        ) async throws -> String {
            let schema = try await PublicContent.Repository
                .OpenAPI(
                    api: AppAPI.Client(
                        environment: environment,
                        requestContext: context
                    )
                )
                .getRouteSettings()
            let settings = Settings.PublicRoutes(schema: schema)
            let prefix = settings[keyPath: keyPath]
            return prefix.isEmpty ? "/" : "/\(prefix)/"
        }
    }
}
