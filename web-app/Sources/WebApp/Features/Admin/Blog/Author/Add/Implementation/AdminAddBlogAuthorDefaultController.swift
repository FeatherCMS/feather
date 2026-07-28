import FeatherValidation
import Foundation
import HTML
import Hummingbird

struct AdminAddBlogAuthorDefaultController: AdminAddBlogAuthorController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddBlogAuthorInteractor,
            presenter: any AdminAddBlogAuthorPresenter
        )

    func getAddBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let slugPrefix = (try? await slugPrefix(context: context)) ?? "/"
        return runtime.presenter.renderAddPage(
            state: formState(
                permissions: permissions,
                slugPrefix: slugPrefix
            ),
            permissions: permissions
        )
    }

    func postAddBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: BlogAuthorFormInput?

        do {
            let payload = try await request.decode(
                as: BlogAuthorFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/blog/authors/",
                        title: "Added",
                        message: "Blog author added successfully."
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions,
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions,
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions,
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
        name: String = "",
        excerpt: String = "",
        content: String = "",
        profileImageAssetId: String? = nil,
        metadata: AdminMetadataFormValue? = nil,
        selectedProfileImage: AdminMediaAssetReferenceModel? = nil,
        permissions: Set<String>,
        slugPrefix: String? = nil
    ) -> BlogAuthorForm.State {
        .init(
            name: .init(key: "name", label: "Name", value: name, error: nil),
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
            metadata: AdminMetadataFieldStateFactory.make(
                metadata,
                slugPrefix: slugPrefix
            ),
            selectedProfileImage: selectedProfileImage,
            canSelectProfileImage: permissions.contains(
                AdminMedia.Scope.assets.permission(for: .read)
            ),
            canUploadProfileImage: permissions.contains(
                AdminMedia.Scope.assets.permission(for: .create)
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
            keyPath: \.authorPathPrefix
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
