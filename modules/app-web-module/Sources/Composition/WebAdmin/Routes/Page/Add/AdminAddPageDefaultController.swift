import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminAddPageDefaultController: AdminAddPageController {
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddPageInteractor,
            any AdminAddPagePresenter
        >

    func getAddPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return try await runtime.presenter.renderAddPage(
            state: formState(slugPrefix: slugPrefix(context: context)),
            permissions: context.currentUserPermissions
        )
    }

    func postAddPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: PageFormInput?

        do {
            let payload = try await request.decode(
                as: PageFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return AdminNotificationFlash.redirect(
                to: PageRoutes.list.description,
                notification: .init(
                    title: "Added",
                    message: "Web page added successfully."
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
                slugPrefix: slugPrefix(context: context)
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
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                slugPrefix: slugPrefix(context: context)
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
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                slugPrefix: slugPrefix(context: context)
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
    ) -> PageForm.State {
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
                label: "Page image",
                value: imageAssetId,
                error: nil
            ),
            selectedImageAsset: nil,
            metadata: AdminMetadataFieldStateFactory.make(
                metadata,
                slugPrefix: slugPrefix
            ),
            error: nil,
            success: nil
        )
    }

    private func slugPrefix(
        context: AuthenticatedRequestContext
    ) -> String {
        "/"
    }
}
