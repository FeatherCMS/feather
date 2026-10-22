import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin
import OpenAPIRuntime
import WebComponents
import WebModuleWebAdmin

extension Author.Edit.Controller {
    struct Default: Interface {
        let routes: Author.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Author.Edit.Interactor.Interface,
                any Author.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            do {
                let author = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.render(
                    id: id,
                    state: formState(
                        name: author.name,
                        excerpt: author.excerpt,
                        content: author.content,
                        profileImageAssetId: author.profileImageAssetId,
                        metadata: author.metadata,
                        selectedProfileImage: author.profileImage,
                        permissions: permissions
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderError(
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
            let runtime = buildRuntime((request, context))
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            var payload: BlogAuthorFormInput?

            do {
                let decoded = try await request.decode(
                    as: BlogAuthorFormInput.self,
                    context: context
                )
                payload = decoded
                try await decoded.validate()
                try await runtime.interactor.update(id: id, input: decoded)
                return AdminNotificationFlash.redirect(
                    to: routes.authorEdit(RouterPath(id)).description,
                    notification: .init(
                        title: "Saved",
                        message: "Author edited successfully."
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
                    permissions: permissions
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
                    name: payload?.normalizedName ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    profileImageAssetId: payload?.normalizedProfileImageAssetId,
                    permissions: permissions
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
                    name: payload?.normalizedName ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    profileImageAssetId: payload?.normalizedProfileImageAssetId,
                    permissions: permissions
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
            name: String = "",
            excerpt: String = "",
            content: String = "",
            profileImageAssetId: String? = nil,
            metadata: AdminMetadataFormValue? = nil,
            selectedProfileImage: AdminMediaAsset? = nil,
            permissions: Set<String>
        ) -> BlogAuthorForm.State {
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
                metadata: AdminMetadataFieldStateFactory.make(metadata),
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
    }
}
