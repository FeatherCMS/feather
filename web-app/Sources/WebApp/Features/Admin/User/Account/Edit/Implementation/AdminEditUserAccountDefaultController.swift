import FeatherValidation
import HTML
import Hummingbird

struct AdminEditUserAccountDefaultController: AdminEditUserAccountController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditUserAccountInteractor,
            presenter: any AdminEditUserAccountPresenter
        )

    func getEditUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        guard let account = context.account else {
            return presenter.renderDeniedPage(
                breadcrumb: breadcrumb(id: id),
                permissions: []
            )
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: .update,
                scope: AdminUser.Scope.accounts
            )
        else {
            return presenter.renderDeniedPage(
                breadcrumb: breadcrumb(id: id),
                permissions: permissions
            )
        }

        do {
            let loaded = try await interactor.loadAccount(id: id)
            let roleOptions = try await safeRoleOptions(interactor: interactor)
            return presenter.renderPage(
                state: .init(
                    id: id,
                    isEdited: request.hasQueryFlag("edited"),
                    form: formState(
                        email: loaded.email,
                        password: "",
                        selectedRoleIds: loaded.roleIds,
                        roleOptions: roleOptions
                    ),
                    breadcrumb: breadcrumb(id: id)
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                state: errorState(id: id, error: error),
                permissions: permissions
            )
        }
    }

    func postEditUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        guard let account = context.account else {
            return
                try presenter.renderDeniedPage(
                    breadcrumb: breadcrumb(id: id),
                    permissions: []
                )
                .response(from: request, context: context)
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: .update,
                scope: AdminUser.Scope.accounts
            )
        else {
            return
                try presenter.renderDeniedPage(
                    breadcrumb: breadcrumb(id: id),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        var lastPayload: AdminEditUserAccountFormInput?
        do {
            let loaded = try await interactor.loadAccount(id: id)
            do {
                let payload = try await request.decode(
                    as: AdminEditUserAccountFormInput.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await interactor.update(
                    entity: .init(
                        id: id,
                        email: payload.normalizedEmail,
                        password: payload.normalizedPassword,
                        roleIds: payload.roleIds ?? []
                    )
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminToastRedirect.location(
                            defaultPath: "/admin/user/accounts/\(id)/edit/",
                            title: "Saved",
                            message: "User account edited successfully."
                        )
                    ]
                )
            }
            catch let error as ValidationError {
                let state = makeFormState(
                    account: loaded,
                    payload: lastPayload,
                    errors: error.failures.reduce(into: [:]) {
                        result,
                        failure in
                        result[failure.key] = failure.message
                    },
                    roleOptions: try await safeRoleOptions(
                        interactor: interactor
                    )
                )
                return try renderEditResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    id: id,
                    permissions: permissions,
                    state: state
                )
            }
            catch let error as OpenAPIRepositoryError {
                let state = makeFormState(
                    account: loaded,
                    payload: lastPayload,
                    error: format(error: error),
                    roleOptions: try await safeRoleOptions(
                        interactor: interactor
                    )
                )
                return try renderEditResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    id: id,
                    permissions: permissions,
                    state: state
                )
            }
            catch {
                let state = makeFormState(
                    account: loaded,
                    payload: lastPayload,
                    error: error.displayMessage,
                    roleOptions: try await safeRoleOptions(
                        interactor: interactor
                    )
                )
                return try renderEditResponse(
                    request: request,
                    context: context,
                    presenter: presenter,
                    id: id,
                    permissions: permissions,
                    state: state
                )
            }
        }
        catch let error as OpenAPIRepositoryError {
            return
                try presenter.renderError(
                    state: errorState(id: id, error: error),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func safeRoleOptions(
        interactor: any AdminEditUserAccountInteractor
    ) async throws -> [AdminEditUserAccountRoleOptionModel] {
        (try? await interactor.loadRoleOptions()) ?? []
    }

    private func makeFormState(
        account: AdminEditUserAccountModel,
        payload: AdminEditUserAccountFormInput? = nil,
        errors: [String: String] = [:],
        error: String? = nil,
        roleOptions: [AdminEditUserAccountRoleOptionModel]
    ) -> UserAccountForm.State {
        var state = formState(
            email: payload?.normalizedEmail ?? account.email,
            password: payload?.password ?? "",
            selectedRoleIds: payload?.roleIds ?? account.roleIds,
            roleOptions: roleOptions
        )
        state.apply(errors: errors)
        state.error = error
        return state
    }

    private func formState(
        email: String = "",
        password: String = "",
        selectedRoleIds: [String] = [],
        roleOptions: [AdminEditUserAccountRoleOptionModel] = []
    ) -> UserAccountForm.State {
        let selectedRoleIdSet = Set(selectedRoleIds)
        return .init(
            email: .init(
                key: "email",
                label: "Email address",
                isRequired: true,
                value: email,
                error: nil
            ),
            password: .init(
                key: "password",
                label: "Password",
                isRequired: false,
                value: password,
                error: nil
            ),
            roleOptions: roleOptions.map {
                .init(
                    key: "roleIds[]",
                    label: $0.name,
                    value: $0.id,
                    isSelected: selectedRoleIdSet.contains($0.id)
                )
            },
            roleIdsError: nil,
            error: nil,
            success: nil
        )
    }

    private func errorState(
        id: String,
        error: OpenAPIRepositoryError
    ) -> UserAccountError.State {
        .init(
            info: infoText(for: error),
            message: messageText(for: error),
            breadcrumb: breadcrumb(id: id)
        )
    }

    private func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }

    private func infoText(
        for error: OpenAPIRepositoryError
    ) -> String {
        error.errorTitle
    }

    private func messageText(
        for error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }

    private func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "User", link: "/admin/user/"),
                .init(label: "Accounts", link: "/admin/user/accounts/"),
                .init(
                    label: "Edit",
                    link: "/admin/user/accounts/\(id)/edit/"
                ),
            ]
        )
    }

    private func renderEditResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminEditUserAccountPresenter,
        id: String,
        permissions: Set<String>,
        state: UserAccountForm.State
    ) throws -> Response {
        try presenter.renderPage(
            state: .init(
                id: id,
                isEdited: false,
                form: state,
                breadcrumb: breadcrumb(id: id)
            ),
            permissions: permissions
        )
        .response(from: request, context: context)
    }
}
