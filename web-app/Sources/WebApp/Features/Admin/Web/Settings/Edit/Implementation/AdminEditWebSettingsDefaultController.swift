import Hummingbird

struct AdminEditWebSettingsDefaultController:
    AdminEditWebSettingsController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebSettingsInteractor,
            presenter: any AdminEditWebSettingsPresenter
        )

    func getEditWebSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let canRead = context.isCurrentUserAllowed(
            to: .read,
            scope: AdminWeb.Scope.settings
        )

        guard canRead else {
            return presenter.renderDeniedPage(
                info: "No permission",
                message: "Your account cannot view the web settings.",
                permissions: permissions
            )
        }

        let settings: AdminEditWebSettingsModel
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

    func postEditWebSettings(
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
                    message: "Your account cannot edit the web settings.",
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        let input = try await request.decode(
            as: AdminEditWebSettingsFormInput.self,
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
                    defaultPath: "/admin/web/settings/",
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            ]
        )
    }

    private func canEdit(
        permissions: Set<String>
    ) -> Bool {
        permissions.contains(AdminWeb.Scope.settings.permission(for: .update))
    }

    private func makeFormState(
        from settings: AdminEditWebSettingsModel,
        canEdit: Bool
    ) -> WebSettingsForm.State {
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
        homePageOptions: [AdminEditWebSettingsHomePageModel],
        locale: String,
        timezone: String,
        title: String,
        excerpt: String,
        noIndex: Bool,
        css: String,
        js: String,
        canEdit: Bool,
        error: String?
    ) -> WebSettingsForm.State {
        .init(
            logo: .init(
                key: WebSettingsVariableKey.logo.fieldKey,
                label: WebSettingsVariableKey.logo.label,
                value: logo,
                error: nil
            ),
            logoDark: .init(
                key: WebSettingsVariableKey.logoDark.fieldKey,
                label: WebSettingsVariableKey.logoDark.label,
                value: logoDark,
                error: nil
            ),
            metaImage: .init(
                key: WebSettingsVariableKey.metaImage.fieldKey,
                label: WebSettingsVariableKey.metaImage.label,
                value: metaImage,
                error: nil
            ),
            primaryColor: .init(
                key: WebSettingsVariableKey.primaryColor.fieldKey,
                label: WebSettingsVariableKey.primaryColor.label,
                value: primaryColor,
                error: nil
            ),
            secondaryColor: .init(
                key: WebSettingsVariableKey.secondaryColor.fieldKey,
                label: WebSettingsVariableKey.secondaryColor.label,
                value: secondaryColor,
                error: nil
            ),
            tertiaryColor: .init(
                key: WebSettingsVariableKey.tertiaryColor.fieldKey,
                label: WebSettingsVariableKey.tertiaryColor.label,
                value: tertiaryColor,
                error: nil
            ),
            primaryFont: .init(
                key: WebSettingsVariableKey.primaryFont.fieldKey,
                label: WebSettingsVariableKey.primaryFont.label,
                value: primaryFont,
                error: nil
            ),
            secondaryFont: .init(
                key: WebSettingsVariableKey.secondaryFont.fieldKey,
                label: WebSettingsVariableKey.secondaryFont.label,
                value: secondaryFont,
                error: nil
            ),
            homePage: .init(
                key: WebSettingsVariableKey.homePageId.fieldKey,
                label: WebSettingsVariableKey.homePageId.label,
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
                key: WebSettingsVariableKey.locale.fieldKey,
                label: WebSettingsVariableKey.locale.label,
                value: locale,
                error: nil
            ),
            timezone: .init(
                key: WebSettingsVariableKey.timezone.fieldKey,
                label: WebSettingsVariableKey.timezone.label,
                value: timezone,
                error: nil
            ),
            title: .init(
                key: WebSettingsVariableKey.title.fieldKey,
                label: WebSettingsVariableKey.title.label,
                value: title,
                error: nil
            ),
            excerpt: .init(
                key: WebSettingsVariableKey.excerpt.fieldKey,
                label: WebSettingsVariableKey.excerpt.label,
                value: excerpt,
                error: nil
            ),
            noIndex: .init(
                key: WebSettingsVariableKey.noIndex.fieldKey,
                label: WebSettingsVariableKey.noIndex.label,
                value: noIndex,
                error: nil
            ),
            css: .init(
                key: WebSettingsVariableKey.css.fieldKey,
                label: WebSettingsVariableKey.css.label,
                value: css,
                error: nil
            ),
            js: .init(
                key: WebSettingsVariableKey.js.fieldKey,
                label: WebSettingsVariableKey.js.label,
                value: js,
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
    ) -> WebSettingsForm.State {
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
            locale: WebSettingsVariableKey.locale.defaultValue,
            timezone: WebSettingsVariableKey.timezone.defaultValue,
            title: "",
            excerpt: "",
            noIndex: false,
            css: "",
            js: "",
            canEdit: canEdit,
            error: error
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Settings", link: "/admin/web/settings/"),
            ]
        )
    }

    private func loadHomePageOptions(
        using interactor: any AdminEditWebSettingsInteractor
    ) async -> [AdminEditWebSettingsHomePageModel] {
        (try? await interactor.loadSettings().homePageOptions) ?? []
    }
}
