import FeatherAdmin
import FeatherValidation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminEditAccountInvitationDefaultController:
    AdminEditAccountInvitationController
{
    let buildRuntime: RuntimeBuilder<
        any AdminEditAccountInvitationInteractor,
        any AdminEditAccountInvitationPresenter
    >

    func getEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        let isEdited = request.hasQueryFlag("edited")
        let permissions = context.currentUserPermissions
        do {
            let invitation = try await interactor.get(id: id)
            return try await presenter.renderEditPage(
                id: id,
                state: presenter.formState(
                    email: invitation.email,
                    roleIDs: invitation.roleIds,
                    roleOptions: await roleOptions(
                        context,
                        selected: invitation.roleIds
                    )
                ),
                isEdited: isEdited,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        let availableRoleOptions = await roleOptions(context, selected: [])
        var lastPayload: AdminEditAccountInvitationFormInput?
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminEditAccountInvitationFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                var state = presenter.formState(
                    email: "",
                    roleIDs: [],
                    roleOptions: availableRoleOptions
                )
                state.error = "This form has expired. Please reload the page."
                return try await updateResponse(
                    request: request,
                    context: context,
                    id: id,
                    presenter: presenter,
                    state: state
                )
            }
            let payload = nonceRequest.input
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: id,
                    email: payload.normalizedEmail,
                    roleIDs: payload.normalizedRoleIDs
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/account/invitations/\(id)/edit/",
                        title: "Saved",
                        message: "User invitation edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                roleOptions: availableRoleOptions
            )
            state.apply(errors: errs)
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                roleOptions: availableRoleOptions
            )
            state.error = presenter.format(error: error)
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                roleOptions: availableRoleOptions
            )
            state.error = error.displayMessage
            return try await updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
    }

    private func roleOptions(
        _ context: DefaultRequestContext,
        selected: [String]
    ) async -> [AccountInvitationForm.RoleOptionState] {
        let userAPI = UserAdminAPIClient(
            apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
            sessionToken: context.sessionToken
        )
        guard
            let response =
                try? await userAPI
                .withOpenAPIRepositoryErrorMapping({ client in
                    try await client.userRoleSearch(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: 100, number: 1),
                                filters: .init(search: nil)
                            )
                        )
                    )
                })
        else { return [] }
        guard case .ok(let value) = response,
            let body = try? value.body.json
        else { return [] }
        return body.data.items.map {
            .init(
                value: $0.id,
                label: $0.name ?? $0.id,
                isSelected: selected.contains($0.id)
            )
        }
    }

    private func updateResponse(
        request: Request,
        context: DefaultRequestContext,
        id: String,
        presenter: any AdminEditAccountInvitationPresenter,
        state: AccountInvitationForm.State
    ) async throws -> Response {
        try await presenter.renderEditPage(
            id: id,
            state: state,
            isEdited: false,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
