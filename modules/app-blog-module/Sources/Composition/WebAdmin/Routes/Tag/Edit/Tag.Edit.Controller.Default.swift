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
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension Tag.Edit.Controller {
    struct Default: Interface {
        let routes: Tag.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Tag.Edit.Interactor.Interface,
                any Tag.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            do {
                let tag = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.render(
                    id: id,
                    state: formState(
                        title: tag.title,
                        excerpt: tag.excerpt,
                        content: tag.content,
                        imageAssetId: tag.imageAsset?.id,
                        imageAsset: tag.imageAsset,
                        metadata: tag.metadata
                    ),
                    permissions: context.currentUserPermissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderError(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: context.currentUserPermissions
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
            var payload: Tag.Form.Input?

            do {
                let decoded = try await request.decode(
                    as: Tag.Form.Input.self,
                    context: context
                )
                payload = decoded
                try await decoded.validate()
                try await runtime.interactor.update(id: id, input: decoded)

                return AdminNotification.redirect(
                    to: routes.tagEditPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Tag edited successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errors: [String: String] = [:]
                for failure in error.failures {
                    errors[failure.key] = failure.message
                }
                var state = formState(
                    title: payload?.normalizedTitle ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    imageAssetId: payload?.normalizedImageAssetId
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
                    title: payload?.normalizedTitle ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    imageAssetId: payload?.normalizedImageAssetId
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
                    title: payload?.normalizedTitle ?? "",
                    excerpt: payload?.normalizedExcerpt ?? "",
                    content: payload?.normalizedContent ?? "",
                    imageAssetId: payload?.normalizedImageAssetId
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
            metadata: AdminMetadataFormValue? = nil
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
                selectedImageAsset: imageAsset,
                metadata: WebModule.Metadata.FieldStateFactory.make(metadata),
                error: nil
            )
        }
    }
}
