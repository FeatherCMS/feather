import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Settings.Edit.Controller {
    struct Default: Interface {
        let routes: Settings.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Settings.Edit.Interactor.Interface,
                any Settings.Edit.Presenter.Interface
            >

        func getEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canRead = context.isCurrentUserAllowed(
                to: WebModule.Permissions.Settings.read
            )

            guard canRead else {
                return try await presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot view the web settings.",
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
                        breadcrumb: routes.breadcrumb,
                        action: routes.edit.path
                    ),
                    permissions: permissions
                )
            }
            let canEdit = canEdit(permissions: permissions)
            return try await presenter.renderPage(
                state: .init(
                    canEdit: canEdit,
                    form: makeFormState(from: settings, canEdit: canEdit),
                    breadcrumb: routes.breadcrumb,
                    action: routes.edit.path
                ),
                permissions: permissions
            )
        }

        func postEditSettings(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canEdit = canEdit(permissions: permissions)

            guard canEdit else {
                return
                    try await presenter.renderDeniedPage(
                        info: "No permission",
                        message: "Your account cannot edit the web settings.",
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            let input = try await request.decode(
                as: Settings.Edit.Form.Input.self,
                context: context
            )
            let errors = input.validationErrors()
            if !errors.isEmpty {
                let homePageOptions = await loadHomePageOptions(
                    using: interactor
                )
                var form = makeFormState(
                    logo: input.normalizedLogo,
                    logoDark: input.normalizedLogoDark,
                    metaImage: input.normalizedMetaImage,
                    primaryColor: input.normalizedPrimaryColor,
                    secondaryColor: input.normalizedSecondaryColor,
                    tertiaryColor: input.normalizedTertiaryColor,
                    primaryFont: input.normalizedPrimaryFont,
                    secondaryFont: input.normalizedSecondaryFont,
                    homePageId: input.normalizedHomePageId,
                    homePageOptions: homePageOptions,
                    locale: input.normalizedLocale,
                    timezone: input.normalizedTimezone,
                    title: input.normalizedTitle,
                    excerpt: input.normalizedExcerpt,
                    noIndex: input.noIndex.value,
                    css: input.normalizedCSS,
                    js: input.normalizedJS,
                    canEdit: canEdit,
                    error: nil
                )
                form.apply(errors: errors)
                return
                    try await presenter.renderPage(
                        state: .init(
                            canEdit: canEdit,
                            form: form,
                            breadcrumb: routes.breadcrumb,
                            action: routes.edit.path
                        ),
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            do {
                try await interactor.saveSettings(input: input)
            }
            catch {
                let homePageOptions = await loadHomePageOptions(
                    using: interactor
                )
                var form = makeFormState(
                    logo: input.normalizedLogo,
                    logoDark: input.normalizedLogoDark,
                    metaImage: input.normalizedMetaImage,
                    primaryColor: input.normalizedPrimaryColor,
                    secondaryColor: input.normalizedSecondaryColor,
                    tertiaryColor: input.normalizedTertiaryColor,
                    primaryFont: input.normalizedPrimaryFont,
                    secondaryFont: input.normalizedSecondaryFont,
                    homePageId: input.normalizedHomePageId,
                    homePageOptions: homePageOptions,
                    locale: input.normalizedLocale,
                    timezone: input.normalizedTimezone,
                    title: input.normalizedTitle,
                    excerpt: input.normalizedExcerpt,
                    noIndex: input.noIndex.value,
                    css: input.normalizedCSS,
                    js: input.normalizedJS,
                    canEdit: canEdit,
                    error: error.displayMessage
                )
                form.apply(errors: errors)
                return
                    try await presenter.renderPage(
                        state: .init(
                            canEdit: canEdit,
                            form: form,
                            breadcrumb: routes.breadcrumb,
                            action: routes.edit.path
                        ),
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            return AdminNotificationFlash.redirect(
                to: routes.edit.path,
                notification: .init(
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            )
        }

        private func canEdit(
            permissions: Set<String>
        ) -> Bool {
            permissions.contains(WebModule.Permissions.Settings.update.rawValue)
        }

        private func makeFormState(
            from settings: Settings.Edit.Model,
            canEdit: Bool
        ) -> Settings.Edit.Form.Component.State {
            makeFormState(
                logo: settings.logo,
                logoDark: settings.logoDark,
                metaImage: settings.metaImage,
                primaryColor: settings.primaryColor,
                secondaryColor: settings.secondaryColor,
                tertiaryColor: settings.tertiaryColor,
                primaryFont: settings.primaryFont,
                secondaryFont: settings.secondaryFont,
                homePageId: settings.homePageId,
                homePageOptions: settings.homePageOptions,
                locale: settings.locale,
                timezone: settings.timezone,
                title: settings.title,
                excerpt: settings.excerpt,
                noIndex: settings.noIndex,
                css: settings.css,
                js: settings.js,
                canEdit: canEdit,
                error: nil
            )
        }

        private func makeFormState(
            logo: String,
            logoDark: String,
            metaImage: String,
            primaryColor: String,
            secondaryColor: String,
            tertiaryColor: String,
            primaryFont: String,
            secondaryFont: String,
            homePageId: String?,
            homePageOptions: [Settings.Edit.Model.HomePage],
            locale: String,
            timezone: String,
            title: String,
            excerpt: String,
            noIndex: Bool,
            css: String,
            js: String,
            canEdit: Bool,
            error: String?
        ) -> Settings.Edit.Form.Component.State {
            .init(
                logo: .init(
                    key: Settings.Edit.VariableKey.logo.fieldKey,
                    label: Settings.Edit.VariableKey.logo.label,
                    value: logo,
                    error: nil
                ),
                logoDark: .init(
                    key: Settings.Edit.VariableKey.logoDark.fieldKey,
                    label: Settings.Edit.VariableKey.logoDark.label,
                    value: logoDark,
                    error: nil
                ),
                metaImage: .init(
                    key: Settings.Edit.VariableKey.metaImage.fieldKey,
                    label: Settings.Edit.VariableKey.metaImage.label,
                    value: metaImage,
                    error: nil
                ),
                primaryColor: .init(
                    key: Settings.Edit.VariableKey.primaryColor.fieldKey,
                    label: Settings.Edit.VariableKey.primaryColor.label,
                    value: primaryColor,
                    error: nil
                ),
                secondaryColor: .init(
                    key: Settings.Edit.VariableKey.secondaryColor.fieldKey,
                    label: Settings.Edit.VariableKey.secondaryColor.label,
                    value: secondaryColor,
                    error: nil
                ),
                tertiaryColor: .init(
                    key: Settings.Edit.VariableKey.tertiaryColor.fieldKey,
                    label: Settings.Edit.VariableKey.tertiaryColor.label,
                    value: tertiaryColor,
                    error: nil
                ),
                primaryFont: .init(
                    key: Settings.Edit.VariableKey.primaryFont.fieldKey,
                    label: Settings.Edit.VariableKey.primaryFont.label,
                    value: primaryFont,
                    error: nil
                ),
                secondaryFont: .init(
                    key: Settings.Edit.VariableKey.secondaryFont.fieldKey,
                    label: Settings.Edit.VariableKey.secondaryFont.label,
                    value: secondaryFont,
                    error: nil
                ),
                homePage: .init(
                    key: Settings.Edit.VariableKey.homePageId.fieldKey,
                    label: Settings.Edit.VariableKey.homePageId.label,
                    value: homePageId,
                    options: homePageOptions.map {
                        .init(
                            label: $0.displayLabel,
                            value: $0.id,
                            isSelected: $0.id == homePageId
                        )
                    },
                    error: nil
                ),
                locale: .init(
                    key: Settings.Edit.VariableKey.locale.fieldKey,
                    label: Settings.Edit.VariableKey.locale.label,
                    value: Self.normalizeLocale(locale),
                    error: nil
                ),
                timezone: .init(
                    key: Settings.Edit.VariableKey.timezone.fieldKey,
                    label: Settings.Edit.VariableKey.timezone.label,
                    value: timezone,
                    error: nil
                ),
                title: .init(
                    key: Settings.Edit.VariableKey.title.fieldKey,
                    label: Settings.Edit.VariableKey.title.label,
                    value: title,
                    error: nil
                ),
                excerpt: .init(
                    key: Settings.Edit.VariableKey.excerpt.fieldKey,
                    label: Settings.Edit.VariableKey.excerpt.label,
                    value: excerpt,
                    error: nil
                ),
                noIndex: .init(
                    key: Settings.Edit.VariableKey.noIndex.fieldKey,
                    label: Settings.Edit.VariableKey.noIndex.label,
                    value: noIndex,
                    error: nil
                ),
                css: .init(
                    key: Settings.Edit.VariableKey.css.fieldKey,
                    label: Settings.Edit.VariableKey.css.label,
                    value: css,
                    error: nil
                ),
                js: .init(
                    key: Settings.Edit.VariableKey.js.fieldKey,
                    label: Settings.Edit.VariableKey.js.label,
                    value: js,
                    error: nil
                ),
                canEdit: canEdit,
                error: error,
                success: nil
            )
        }

        private static func normalizeLocale(_ value: String) -> String {
            switch value {
            case "en_us":
                "en-US"
            default:
                value
            }
        }

        private func makeFormState(
            canEdit: Bool,
            error: String?
        ) -> Settings.Edit.Form.Component.State {
            makeFormState(
                logo: "",
                logoDark: "",
                metaImage: "",
                primaryColor: "",
                secondaryColor: "",
                tertiaryColor: "",
                primaryFont: "",
                secondaryFont: "",
                homePageId: nil,
                homePageOptions: [],
                locale: Settings.Edit.VariableKey.locale.defaultValue,
                timezone: Settings.Edit.VariableKey.timezone.defaultValue,
                title: "",
                excerpt: "",
                noIndex: false,
                css: "",
                js: "",
                canEdit: canEdit,
                error: error
            )
        }

        private func loadHomePageOptions(
            using interactor: any Settings.Edit.Interactor.Interface
        ) async -> [Settings.Edit.Model.HomePage] {
            (try? await interactor.loadSettings().homePageOptions) ?? []
        }
    }
}
