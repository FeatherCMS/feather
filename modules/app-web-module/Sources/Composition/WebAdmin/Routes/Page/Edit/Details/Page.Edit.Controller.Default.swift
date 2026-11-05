import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Edit.Controller {
    struct Default: Interface {
        let routes: Page.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Page.Edit.Interactor.Interface,
                any Page.Edit.Presenter.Interface
            >

        func getEditPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            do {
                let page = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.renderEditPage(
                    id: id,
                    state: formState(
                        context: context,
                        title: page.title,
                        excerpt: page.excerpt,
                        content: page.content,
                        imageAssetId: page.imageAsset?.id,
                        imageAsset: page.imageAsset,
                        metadata: page.metadata
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }

        func postEditPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            var lastPayload: Page.Form.Input?

            do {
                let payload = try await request.decode(
                    as: Page.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.update(id: id, input: payload)

                return AdminNotification.redirect(
                    to: routes.editPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Page edited successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errors: [String: String] = [:]
                for failure in error.failures {
                    errors[failure.key] = failure.message
                }
                let page = try? await runtime.interactor.load(id: id)
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    metadata: page?.metadata
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .renderEditPage(
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                let page = try? await runtime.interactor.load(id: id)
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    metadata: page?.metadata
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .renderEditPage(
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                let page = try? await runtime.interactor.load(id: id)
                var state = formState(
                    context: context,
                    title: lastPayload?.normalizedTitle ?? "",
                    excerpt: lastPayload?.normalizedExcerpt ?? "",
                    content: lastPayload?.normalizedContent ?? "",
                    imageAssetId: lastPayload?.normalizedImageAssetId,
                    metadata: page?.metadata
                )
                state.error = error.displayMessage
                return try await runtime.presenter
                    .renderEditPage(
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
        }

        private func formState(
            context: AuthenticatedRequestContext,
            title: String = "",
            excerpt: String = "",
            content: String = "",
            imageAssetId: String? = nil,
            imageAsset: AdminMediaAsset? = nil,
            metadata: AdminMetadataFormValue? = nil
        ) -> Page.Form.Component.State {
            let slug = metadata?.slug
                .split(separator: "/")
                .joined(separator: "/") ?? ""
            let mediaFolderPath = slug.isEmpty
                ? "web/pages"
                : "web/pages/\(slug)"
            return .init(
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
                    label: "Page image",
                    value: imageAssetId,
                    error: nil
                ),
                selectedImageAsset: imageAsset,
                mediaFolderPath: mediaFolderPath,
                metadata: WebModule.Metadata.FieldStateFactory.make(
                    metadata,
                    dateFormatter: context.adminDateFormatter
                ),
                error: nil,
                success: nil
            )
        }
    }
}
