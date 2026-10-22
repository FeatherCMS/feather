import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Settings.Edit.Controller {
    struct Default: Interface {
        let routes: Settings.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Settings.Edit.Interactor.Interface,
                any Settings.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let permissions = context.currentUserPermissions
            let canRead = context.isCurrentUserAllowed(
                to: Settings.Permissions.read
            )

            guard canRead else {
                return try await presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot view the blog settings.",
                    permissions: permissions
                )
            }

            let settings: Settings.Edit.Model
            do {
                settings = try await interactor.loadSettings()
            }
            catch {
                let canEdit = canEdit(permissions: permissions)
                return try await presenter.renderPage(
                    state: .init(
                        canEdit: canEdit,
                        form: makeFormState(
                            canEdit: canEdit,
                            error: error.displayMessage
                        ),
                        breadcrumb: routes.breadcrumb
                    ),
                    permissions: permissions
                )
            }
            let canEdit = canEdit(permissions: permissions)
            return try await presenter.renderPage(
                state: .init(
                    canEdit: canEdit,
                    form: makeFormState(from: settings, canEdit: canEdit),
                    breadcrumb: routes.breadcrumb
                ),
                permissions: permissions
            )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let (interactor, presenter) = buildRuntime((request, context))
            let permissions = context.currentUserPermissions
            let canEdit = canEdit(permissions: permissions)

            guard canEdit else {
                return
                    try await presenter.renderDeniedPage(
                        info: "No permission",
                        message: "Your account cannot edit the blog settings.",
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            let input = try await request.decode(
                as: Settings.Edit.FormInput.self,
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
                    try await presenter.renderPage(
                        state: .init(
                            canEdit: canEdit,
                            form: form,
                            breadcrumb: routes.breadcrumb
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
                    try await presenter.renderPage(
                        state: .init(
                            canEdit: canEdit,
                            form: form,
                            breadcrumb: routes.breadcrumb
                        ),
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            return AdminNotificationFlash.redirect(
                to: routes.settings.path,
                notification: .init(
                    title: "Saved",
                    message: "Blog settings updated successfully."
                )
            )
        }

        private func canEdit(
            permissions: Set<String>
        ) -> Bool {
            permissions.contains(
                Settings.Permissions.update.rawValue
            )
        }

        private func makeFormState(
            from settings: Settings.Edit.Model,
            canEdit: Bool
        ) -> Settings.Edit.Form.State {
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
        ) -> Settings.Edit.Form.State {
            .init(
                postListPath: .init(
                    key: Settings.Edit.VariableKey.postListPath.fieldKey,
                    label: Settings.Edit.VariableKey.postListPath.label,
                    value: postListPath,
                    error: nil
                ),
                authorListPath: .init(
                    key: Settings.Edit.VariableKey.authorListPath.fieldKey,
                    label: Settings.Edit.VariableKey.authorListPath.label,
                    value: authorListPath,
                    error: nil
                ),
                tagListPath: .init(
                    key: Settings.Edit.VariableKey.tagListPath.fieldKey,
                    label: Settings.Edit.VariableKey.tagListPath.label,
                    value: tagListPath,
                    error: nil
                ),
                postPathPrefix: .init(
                    key: Settings.Edit.VariableKey.postPathPrefix.fieldKey,
                    label: Settings.Edit.VariableKey.postPathPrefix.label,
                    value: postPathPrefix,
                    error: nil
                ),
                authorPathPrefix: .init(
                    key: Settings.Edit.VariableKey.authorPathPrefix.fieldKey,
                    label: Settings.Edit.VariableKey.authorPathPrefix.label,
                    value: authorPathPrefix,
                    error: nil
                ),
                tagPathPrefix: .init(
                    key: Settings.Edit.VariableKey.tagPathPrefix.fieldKey,
                    label: Settings.Edit.VariableKey.tagPathPrefix.label,
                    value: tagPathPrefix,
                    error: nil
                ),
                canEdit: canEdit,
                error: error
            )
        }

        private func makeFormState(
            canEdit: Bool,
            error: String?
        ) -> Settings.Edit.Form.State {
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

    }
}
