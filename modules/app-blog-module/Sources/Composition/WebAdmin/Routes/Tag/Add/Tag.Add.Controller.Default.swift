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
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Tag.Add.Controller {
    struct Default: Interface {
        let routes: Tag.Router.Routes
        let buildPublicContentRepository:
            @Sendable (AuthenticatedRequestContext) -> any PublicContent
                .Repository.Interface
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Tag.Add.Interactor.Interface,
                any Tag.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            return try await runtime.presenter.renderAddPage(
                state: formState(slugPrefix: slugPrefix),
                permissions: context.currentUserPermissions
            )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            var lastPayload: Tag.Form.Input?

            do {
                let payload = try await request.decode(
                    as: Tag.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.execute(input: payload)

                return AdminNotification.redirect(
                    to: routes.tags.path,
                    notification: .init(
                        title: "Added",
                        message: "Blog tag added successfully."
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
                    slugPrefix: slugPrefix
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .renderAddPage(
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
                    slugPrefix: slugPrefix
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .renderAddPage(
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
                    slugPrefix: slugPrefix
                )
                state.error = error.displayMessage
                return try await runtime.presenter
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
            slugPrefix: String? = nil
        ) -> Tag.Form.State {
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
                    label: "Tag image",
                    value: imageAssetId,
                    error: nil
                ),
                selectedImageAsset: nil,
                metadata: WebModule.Metadata.FieldStateFactory.make(
                    metadata,
                    slugPrefix: slugPrefix
                ),
                error: nil
            )
        }

        private func slugPrefix(
            context: AuthenticatedRequestContext
        ) async throws -> String {
            try await slugPrefix(
                context: context,
                keyPath: \.tagPathPrefix
            )
        }

        private func slugPrefix(
            context: AuthenticatedRequestContext,
            keyPath: KeyPath<BlogModule.Settings.PublicRoutes, String>
        ) async throws -> String {
            let settings = try await buildPublicContentRepository(context)
                .getRouteSettings()
            let prefix = settings[keyPath: keyPath]
            return prefix.isEmpty ? "/" : "/\(prefix)/"
        }
    }
}
