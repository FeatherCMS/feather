import Hummingbird

struct AdminEditBlogSettingsDefaultController:
    AdminEditBlogSettingsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditBlogSettingsInteractor,
            presenter: any AdminEditBlogSettingsPresenter
        )

    func getEditBlogSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canRead = context.isCurrentUserAllowed(
            to: .read,
            scope: AdminBlog.Scope.settings
        )

        guard canRead else {
            return presenter.renderDeniedPage(
                info: "No permission",
                message: "Your account cannot view the blog settings.",
                permissions: permissions
            )
        }

        let settings: AdminEditBlogSettingsModel
        do {
            settings = try await interactor.loadSettings()
        }
        catch {
            let canEdit = canEdit(permissions: permissions)
            return presenter.renderPage(
                state: .init(
                    isEdited: false,
                    canEdit: canEdit,
                    form: makeFormState(
                        canEdit: canEdit,
                        error: error.displayMessage
                    ),
                    breadcrumb: breadcrumb()
                ),
                permissions: permissions
            )
        }
        let canEdit = canEdit(permissions: permissions)
        return presenter.renderPage(
            state: .init(
                isEdited: request.hasQueryFlag("edited"),
                canEdit: canEdit,
                form: makeFormState(from: settings, canEdit: canEdit),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    func postEditBlogSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canEdit = canEdit(permissions: permissions)

        guard canEdit else {
            return
                try presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot edit the blog settings.",
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        let input = try await request.decode(
            as: AdminEditBlogSettingsFormInput.self,
            context: context
        )
        let errors = input.validationErrors()
        if !errors.isEmpty {
            var form = makeFormState(
                postListPath: input.normalizedPostListPath,
                authorListPath: input.normalizedAuthorListPath,
                tagListPath: input.normalizedTagListPath,
                postPathPrefix: input.normalizedPostPathPrefix,
                authorPathPrefix: input.normalizedAuthorPathPrefix,
                tagPathPrefix: input.normalizedTagPathPrefix,
                canEdit: canEdit,
                error: nil
            )
            form.apply(errors: errors)
            return
                try presenter.renderPage(
                    state: .init(
                        isEdited: false,
                        canEdit: canEdit,
                        form: form,
                        breadcrumb: breadcrumb()
                    ),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        do {
            try await interactor.saveSettings(input: input)
        }
        catch {
            var form = makeFormState(
                postListPath: input.normalizedPostListPath,
                authorListPath: input.normalizedAuthorListPath,
                tagListPath: input.normalizedTagListPath,
                postPathPrefix: input.normalizedPostPathPrefix,
                authorPathPrefix: input.normalizedAuthorPathPrefix,
                tagPathPrefix: input.normalizedTagPathPrefix,
                canEdit: canEdit,
                error: error.displayMessage
            )
            form.apply(errors: errors)
            return
                try presenter.renderPage(
                    state: .init(
                        isEdited: false,
                        canEdit: canEdit,
                        form: form,
                        breadcrumb: breadcrumb()
                    ),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/blog/settings/",
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            ]
        )
    }

    private func canEdit(
        permissions: Set<String>
    ) -> Bool {
        permissions.contains(AdminBlog.Scope.settings.permission(for: .update))
    }

    private func makeFormState(
        from settings: AdminEditBlogSettingsModel,
        canEdit: Bool
    ) -> BlogSettingsForm.State {
        makeFormState(
            postListPath: settings.postListPath,
            authorListPath: settings.authorListPath,
            tagListPath: settings.tagListPath,
            postPathPrefix: settings.postPathPrefix,
            authorPathPrefix: settings.authorPathPrefix,
            tagPathPrefix: settings.tagPathPrefix,
            canEdit: canEdit,
            error: nil
        )
    }

    private func makeFormState(
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String,
        canEdit: Bool,
        error: String?
    ) -> BlogSettingsForm.State {
        .init(
            postListPath: .init(
                key: BlogSettingsVariableKey.postListPath.fieldKey,
                label: BlogSettingsVariableKey.postListPath.label,
                value: postListPath,
                error: nil
            ),
            authorListPath: .init(
                key: BlogSettingsVariableKey.authorListPath.fieldKey,
                label: BlogSettingsVariableKey.authorListPath.label,
                value: authorListPath,
                error: nil
            ),
            tagListPath: .init(
                key: BlogSettingsVariableKey.tagListPath.fieldKey,
                label: BlogSettingsVariableKey.tagListPath.label,
                value: tagListPath,
                error: nil
            ),
            postPathPrefix: .init(
                key: BlogSettingsVariableKey.postPathPrefix.fieldKey,
                label: BlogSettingsVariableKey.postPathPrefix.label,
                value: postPathPrefix,
                error: nil
            ),
            authorPathPrefix: .init(
                key: BlogSettingsVariableKey.authorPathPrefix.fieldKey,
                label: BlogSettingsVariableKey.authorPathPrefix.label,
                value: authorPathPrefix,
                error: nil
            ),
            tagPathPrefix: .init(
                key: BlogSettingsVariableKey.tagPathPrefix.fieldKey,
                label: BlogSettingsVariableKey.tagPathPrefix.label,
                value: tagPathPrefix,
                error: nil
            ),
            canEdit: canEdit,
            error: error,
            success: nil
        )
    }

    private func makeFormState(
        canEdit: Bool,
        error: String?
    ) -> BlogSettingsForm.State {
        makeFormState(
            postListPath: "",
            authorListPath: "",
            tagListPath: "",
            postPathPrefix: "",
            authorPathPrefix: "",
            tagPathPrefix: "",
            canEdit: canEdit,
            error: error
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Settings", link: "/admin/blog/settings/"),
            ]
        )
    }
}
