import FeatherValidation
import HTML
import Hummingbird

struct AdminAddWebPageDefaultController: AdminAddWebPageController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddWebPageInteractor,
            presenter: any AdminAddWebPagePresenter
        )

    func getAddWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return runtime.presenter.renderAddPage(
            state: formState(slugPrefix: slugPrefix(context: context)),
            permissions: context.currentUserPermissions
        )
    }

    func postAddWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: WebPageFormInput?

        do {
            let payload = try await request.decode(
                as: WebPageFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/pages/",
                        title: "Added",
                        message: "Web page added successfully."
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
                slugPrefix: slugPrefix(context: context)
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
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                slugPrefix: slugPrefix(context: context)
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
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                slugPrefix: slugPrefix(context: context)
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
        slugPrefix: String? = nil
    ) -> WebPageForm.State {
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
        context: AppRequestContext
    ) -> String {
        "/"
    }
}
