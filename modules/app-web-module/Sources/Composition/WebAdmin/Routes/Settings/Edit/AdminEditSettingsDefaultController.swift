import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminEditSettingsDefaultController:
    AdminEditSettingsController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminEditSettingsInteractor,
            any AdminEditSettingsPresenter
        >

    func getEditSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
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

        let settings: AdminEditSettingsModel
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
                    breadcrumb: SettingsRoutes.breadcrumb
                ),
                permissions: permissions
            )
        }
        let canEdit = canEdit(permissions: permissions)
        return try await presenter.renderPage(
            state: .init(
                canEdit: canEdit,
                form: makeFormState(from: settings, canEdit: canEdit),
                breadcrumb: SettingsRoutes.breadcrumb
            ),
            permissions: permissions
        )
    }

    func postEditSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
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
            as: AdminEditSettingsFormInput.self,
            context: context
        )
        let errors = input.validationErrors()
        if !errors.isEmpty {
            let homePageOptions = await loadHomePageOptions(using: interactor)
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
                        breadcrumb: SettingsRoutes.breadcrumb
                    ),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        do {
            try await interactor.saveSettings(input: input)
        }
        catch {
            let homePageOptions = await loadHomePageOptions(using: interactor)
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
                        breadcrumb: SettingsRoutes.breadcrumb
                    ),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        return AdminNotificationFlash.redirect(
            to: SettingsRoutes.edit.description,
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
        from settings: AdminEditSettingsModel,
        canEdit: Bool
    ) -> SettingsForm.State {
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
        homePageOptions: [AdminEditSettingsHomePageModel],
        locale: String,
        timezone: String,
        title: String,
        excerpt: String,
        noIndex: Bool,
        css: String,
        js: String,
        canEdit: Bool,
        error: String?
    ) -> SettingsForm.State {
        .init(
            logo: .init(
                key: SettingsVariableKey.logo.fieldKey,
                label: SettingsVariableKey.logo.label,
                value: logo,
                error: nil
            ),
            logoDark: .init(
                key: SettingsVariableKey.logoDark.fieldKey,
                label: SettingsVariableKey.logoDark.label,
                value: logoDark,
                error: nil
            ),
            metaImage: .init(
                key: SettingsVariableKey.metaImage.fieldKey,
                label: SettingsVariableKey.metaImage.label,
                value: metaImage,
                error: nil
            ),
            primaryColor: .init(
                key: SettingsVariableKey.primaryColor.fieldKey,
                label: SettingsVariableKey.primaryColor.label,
                value: primaryColor,
                error: nil
            ),
            secondaryColor: .init(
                key: SettingsVariableKey.secondaryColor.fieldKey,
                label: SettingsVariableKey.secondaryColor.label,
                value: secondaryColor,
                error: nil
            ),
            tertiaryColor: .init(
                key: SettingsVariableKey.tertiaryColor.fieldKey,
                label: SettingsVariableKey.tertiaryColor.label,
                value: tertiaryColor,
                error: nil
            ),
            primaryFont: .init(
                key: SettingsVariableKey.primaryFont.fieldKey,
                label: SettingsVariableKey.primaryFont.label,
                value: primaryFont,
                error: nil
            ),
            secondaryFont: .init(
                key: SettingsVariableKey.secondaryFont.fieldKey,
                label: SettingsVariableKey.secondaryFont.label,
                value: secondaryFont,
                error: nil
            ),
            homePage: .init(
                key: SettingsVariableKey.homePageId.fieldKey,
                label: SettingsVariableKey.homePageId.label,
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
                key: SettingsVariableKey.locale.fieldKey,
                label: SettingsVariableKey.locale.label,
                value: Self.normalizeLocale(locale),
                error: nil
            ),
            timezone: .init(
                key: SettingsVariableKey.timezone.fieldKey,
                label: SettingsVariableKey.timezone.label,
                value: timezone,
                error: nil
            ),
            title: .init(
                key: SettingsVariableKey.title.fieldKey,
                label: SettingsVariableKey.title.label,
                value: title,
                error: nil
            ),
            excerpt: .init(
                key: SettingsVariableKey.excerpt.fieldKey,
                label: SettingsVariableKey.excerpt.label,
                value: excerpt,
                error: nil
            ),
            noIndex: .init(
                key: SettingsVariableKey.noIndex.fieldKey,
                label: SettingsVariableKey.noIndex.label,
                value: noIndex,
                error: nil
            ),
            css: .init(
                key: SettingsVariableKey.css.fieldKey,
                label: SettingsVariableKey.css.label,
                value: css,
                error: nil
            ),
            js: .init(
                key: SettingsVariableKey.js.fieldKey,
                label: SettingsVariableKey.js.label,
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
    ) -> SettingsForm.State {
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
            locale: SettingsVariableKey.locale.defaultValue,
            timezone: SettingsVariableKey.timezone.defaultValue,
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
        using interactor: any AdminEditSettingsInteractor
    ) async -> [AdminEditSettingsHomePageModel] {
        (try? await interactor.loadSettings().homePageOptions) ?? []
    }
}
