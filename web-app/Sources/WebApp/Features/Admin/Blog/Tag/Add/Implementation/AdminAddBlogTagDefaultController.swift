import FeatherValidation
import Foundation
import HTML
import Hummingbird

struct AdminAddBlogTagDefaultController: AdminAddBlogTagController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddBlogTagInteractor,
            presenter: any AdminAddBlogTagPresenter
        )

    func getAddBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
        return runtime.presenter.renderAddPage(
            state: formState(slugPrefix: slugPrefix),
            permissions: context.currentUserPermissions
        )
    }

    func postAddBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: BlogTagFormInput?

        do {
            let payload = try await request.decode(
                as: BlogTagFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/blog/tags/",
                        title: "Added",
                        message: "Blog tag added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
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
                slugPrefix: slugPrefix
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
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                slugPrefix: slugPrefix
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
            let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
            var state = formState(
                title: lastPayload?.normalizedTitle ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                imageAssetId: lastPayload?.normalizedImageAssetId,
                metadata: lastPayload?.metadataValue,
                slugPrefix: slugPrefix
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
    ) -> BlogTagForm.State {
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
    ) async throws -> String {
        try await slugPrefix(
            context: context,
            keyPath: \.tagPathPrefix
        )
    }

    private func slugPrefix(
        context: AppRequestContext,
        keyPath: KeyPath<AppPublicBlogRouteSettings, String>
    ) async throws -> String {
        let schema = try await AppPublicContentOpenAPIRepository(
            api: context.applicationAPI()
        )
        .getRouteSettings()
        let settings = AppPublicBlogRouteSettings(schema: schema)
        let prefix = settings[keyPath: keyPath]
        return prefix.isEmpty ? "/" : "/\(prefix)/"
    }
}
