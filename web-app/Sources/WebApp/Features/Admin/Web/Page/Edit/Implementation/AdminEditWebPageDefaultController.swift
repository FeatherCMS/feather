import FeatherValidation
import HTML
import Hummingbird

struct AdminEditWebPageDefaultController:
    AdminEditWebPageController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebPageInteractor,
            presenter: any AdminEditWebPagePresenter
        )

    func getEditWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let page = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    title: page.title,
                    excerpt: page.excerpt,
                    content: page.content,
                    imageAssetId: page.imageAssetId,
                    imageAsset: page.imageAsset,
                    metadata: page.metadata
                ),
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: WebPageFormInput?

        do {
            let payload = try await request.decode(
                as: WebPageFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/pages/\(id)/edit/",
                        title: "Saved",
                        message: "Page edited successfully."
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
                metadata: lastPayload?.metadataValue
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
                metadata: lastPayload?.metadataValue
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
                metadata: lastPayload?.metadataValue
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
        imageAsset: AdminMediaAssetReferenceModel? = nil,
        metadata: AdminMetadataFormValue? = nil
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
            selectedImageAsset: imageAsset,
            metadata: AdminMetadataFieldStateFactory.make(metadata),
            error: nil,
            success: nil
        )
    }
}
