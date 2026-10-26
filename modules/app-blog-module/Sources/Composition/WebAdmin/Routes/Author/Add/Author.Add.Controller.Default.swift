import BlogAdminAPI
import BlogAppAPI
import BlogModule
import BlogWebShared
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Author.Add.Controller {
    struct Default: Interface {
        let routes: Author.Router.Routes
        let buildPublicContentRepository:
            @Sendable (AuthenticatedRequestContext) -> any PublicContent
                .Repository.Interface
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Author.Add.Interactor.Interface,
                any Author.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            let prefix = (try? await slugPrefix(context: context)) ?? "/"
            return try await runtime.presenter.render(
                state: formState(permissions: permissions, slugPrefix: prefix),
                permissions: permissions
            )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            var payload: Author.Form.Input?

            do {
                let decoded = try await request.decode(
                    as: Author.Form.Input.self,
                    context: context
                )
                payload = decoded
                try await decoded.validate()
                try await runtime.interactor.execute(input: decoded)
                return AdminNotification.redirect(
                    to: routes.authors.path,
                    notification: .init(
                        title: "Added",
                        message: "Blog author added successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errors: [String: String] = [:]
                for failure in error.failures {
                    errors[failure.key] = failure.message
                }
                var state = formState(
                    name: payload?.normalizedName ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    profileImageAssetId: payload?.normalizedProfileImageAssetId,
                    permissions: permissions,
                    slugPrefix: await resolvedSlugPrefix(context: context)
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
                var state = formState(
                    name: payload?.normalizedName ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    profileImageAssetId: payload?.normalizedProfileImageAssetId,
                    permissions: permissions,
                    slugPrefix: await resolvedSlugPrefix(context: context)
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
                var state = formState(
                    name: payload?.normalizedName ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    profileImageAssetId: payload?.normalizedProfileImageAssetId,
                    permissions: permissions,
                    slugPrefix: await resolvedSlugPrefix(context: context)
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
            name: String = "",
            excerpt: String = "",
            content: String = "",
            profileImageAssetId: String? = nil,
            metadata: AdminMetadataFormValue? = nil,
            selectedProfileImage: AdminMediaAsset? = nil,
            permissions: Set<String>,
            slugPrefix: String? = nil
        ) -> Author.Form.State {
            .init(
                name: .init(
                    key: "name",
                    label: "Name",
                    value: name,
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
                profileImageAssetId: .init(
                    key: "profileImageAssetId",
                    label: "Profile picture",
                    value: profileImageAssetId,
                    error: nil
                ),
                metadata: WebModule.Metadata.FieldStateFactory.make(
                    metadata,
                    slugPrefix: slugPrefix
                ),
                selectedProfileImage: selectedProfileImage,
                canSelectProfileImage: permissions.contains(
                    Asset.Permissions.read.rawValue
                ),
                canUploadProfileImage: permissions.contains(
                    Asset.Permissions.create.rawValue
                ),
                error: nil
            )
        }

        private func resolvedSlugPrefix(
            context: AuthenticatedRequestContext
        ) async -> String {
            (try? await slugPrefix(context: context)) ?? "/"
        }

        private func slugPrefix(
            context: AuthenticatedRequestContext
        ) async throws -> String {
            let settings = try await buildPublicContentRepository(context)
                .getRouteSettings()
            let prefix = settings.authorPathPrefix
            return prefix.isEmpty ? "/" : "/\(prefix)/"
        }
    }
}
