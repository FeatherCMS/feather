import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminEditAccountInvitationDefaultController:
    AdminEditAccountInvitationController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAccountInvitationInteractor,
            presenter: any AdminEditAccountInvitationPresenter
        )

    func getEditAccountInvitation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let isEdited = request.hasQueryFlag("edited")
        let permissions = context.currentUserPermissions
        do {
            let invitation = try await interactor.get(id: id)
            return presenter.renderEditPage(
                id: id,
                state: presenter.formState(
                    email: invitation.email,
                    roleIDs: invitation.roleIds,
                    roleOptions: await roleOptions(
                        context, selected: invitation.roleIds
                    )
                ),
                isEdited: isEdited,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderErrorPage(
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
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let availableRoleOptions = await roleOptions(context, selected: [])
        var lastPayload: AdminEditAccountInvitationFormInput?
        do {
            let payload = try await request.decode(
                as: AdminEditAccountInvitationFormInput.self,
                context: context
            )
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
                    .location: AdminToastRedirect.location(
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
            return try updateResponse(
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
            return try updateResponse(
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
            return try updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
    }

    private func roleOptions(
        _ context: AppRequestContext,
        selected: [String]
    ) async -> [AccountInvitationForm.RoleOptionState] {
        guard let response = try? await context.userAdminAPI()
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
            }) else { return [] }
        guard case .ok(let value) = response,
            let body = try? value.body.json else { return [] }
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
    ) throws -> Response {
        try presenter.renderEditPage(
            id: id,
            state: state,
            isEdited: false,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
