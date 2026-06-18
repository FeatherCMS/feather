import FeatherValidation
import HTML
import Hummingbird

struct AdminEditBlogAuthorDefaultController:
    AdminEditBlogAuthorController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditBlogAuthorInteractor,
            presenter: any AdminEditBlogAuthorPresenter
        )

    func getEditBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let menu = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    name: menu.name,
                    excerpt: menu.excerpt,
                    content: menu.content,
                    profileImageAssetId: menu.profileImageAssetId,
                    metadata: menu.metadata,
                    selectedProfileImage: menu.profileImage,
                    permissions: permissions
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

    func postEditBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: BlogAuthorFormInput?

        do {
            let payload = try await request.decode(
                as: BlogAuthorFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/blog/authors/\(id)/edit/",
                        title: "Saved",
                        message: "Author edited successfully."
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions
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
                name: lastPayload?.normalizedName ?? "",
                excerpt: lastPayload?.normalizedExcerpt ?? "",
                content: lastPayload?.normalizedContent ?? "",
                profileImageAssetId: lastPayload?.normalizedProfileImageAssetId,
                metadata: lastPayload?.metadataValue,
                permissions: permissions
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
        name: String = "",
        excerpt: String = "",
        content: String = "",
        profileImageAssetId: String? = nil,
        metadata: AdminMetadataFormValue? = nil,
        selectedProfileImage: AdminMediaAssetReferenceModel? = nil,
        permissions: Set<String>
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
            metadata: AdminMetadataFieldStateFactory.make(metadata),
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
}
