import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import UserContracts

struct AdminEditUserIdentityDefaultController: AdminEditUserIdentityController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditUserIdentityInteractor,
            presenter: any AdminEditUserIdentityPresenter
        )

    func getEditUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        guard
            context.isCurrentUserAllowed(
                to: UserPermissions.Identities.update
            )
        else {
            return presenter.renderDeniedPage(
                breadcrumb: breadcrumb(id: id),
                permissions: permissions
            )
        }

        do {
            let loaded = try await interactor.loadIdentity(id: id)
            let roleOptions = try await safeRoleOptions(interactor: interactor)
            return presenter.renderPage(
                state: .init(
                    id: id,
                    isEdited: request.hasQueryFlag("edited"),
                    form: formState(
                        status: loaded.status,
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

    func postEditUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        guard
            context.isCurrentUserAllowed(
                to: UserPermissions.Identities.update
            )
        else {
            return
                try presenter.renderDeniedPage(
                    breadcrumb: breadcrumb(id: id),
                    permissions: permissions
                )
                .response(from: request, context: context)
        }

        var lastPayload: AdminEditUserIdentityFormInput?
        do {
            let loaded = try await interactor.loadIdentity(id: id)
            do {
                let payload = try await request.decode(
                    as: AdminEditUserIdentityFormInput.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await interactor.update(
                    entity: .init(
                        id: id,
                        status: payload.normalizedStatus,
                        roleIds: payload.roleIds ?? []
                    )
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminToastRedirect.location(
                            defaultPath: "/admin/user/identities/\(id)/edit/",
                            title: "Saved",
                            message: "User identity edited successfully."
                        )
                    ]
                )
            }
            catch let error as ValidationError {
                let state = makeFormState(
                    identity: loaded,
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
                    identity: loaded,
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
                    identity: loaded,
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
        interactor: any AdminEditUserIdentityInteractor
    ) async throws -> [AdminEditUserIdentityRoleOptionModel] {
        (try? await interactor.loadRoleOptions()) ?? []
    }

    private func makeFormState(
        identity: AdminEditUserIdentityModel,
        payload: AdminEditUserIdentityFormInput? = nil,
        errors: [String: String] = [:],
        error: String? = nil,
        roleOptions: [AdminEditUserIdentityRoleOptionModel]
    ) -> UserIdentityForm.State {
        var state = formState(
            status: payload?.normalizedStatus ?? identity.status,
            selectedRoleIds: payload?.roleIds ?? identity.roleIds,
            roleOptions: roleOptions
        )
        state.apply(errors: errors)
        state.error = error
        return state
    }

    private func formState(
        status: String = "invited",
        selectedRoleIds: [String] = [],
        roleOptions: [AdminEditUserIdentityRoleOptionModel] = []
    ) -> UserIdentityForm.State {
        let selectedRoleIdSet = Set(selectedRoleIds)
        return .init(
            status: .init(
                key: "status",
                label: "Status",
                isRequired: true,
                value: status,
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
    ) -> UserIdentityError.State {
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
                .init(label: "Identities", link: "/admin/user/identities/"),
                .init(
                    label: "Edit",
                    link: "/admin/user/identities/\(id)/edit/"
                ),
            ]
        )
    }

    private func renderEditResponse(
        request: Request,
        context: DefaultRequestContext,
        presenter: any AdminEditUserIdentityPresenter,
        id: String,
        permissions: Set<String>,
        state: UserIdentityForm.State
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
