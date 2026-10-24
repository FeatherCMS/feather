import AccountModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Edit.Controller {

    struct Default:
        Invitation.Edit.Controller.Interface
    {
        let environment: AppEnvironment
        let routes: Invitation.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Invitation.Edit.Interactor.Interface,
                any Invitation.Edit.Presenter.Interface
            >

        func getEditAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let id = try context.requiredID()
            let availableRoleOptions = await roleOptions(context, selected: [])
            var lastPayload: Invitation.Edit.Form.Input?
            do {
                let nonceRequest = try await request.decode(
                    as: NonceRequest<Invitation.Edit.Form.Input>.self,
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
                    state.error =
                        "This form has expired. Please reload the page."
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
                            defaultPath:
                                routes.invitationEdit(id) + "/",
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
            _ context: AuthenticatedRequestContext,
            selected: [String]
        ) async -> [Invitation.Form.Component.RoleOptionState] {
            let userAPI = UserWebAdmin.API.Client(
                apiBaseURL: environment.apiBaseURL,
                requestContext: context
            )
            guard
                let response =
                    try? await userAPI
                    .withOpenAPIRepositoryErrorMapping({ client in
                        try await client.userRoleList(
                            query: .init(limit: 100),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                    })
            else { return [] }
            guard case .ok(let value) = response,
                let body = try? value.body.json
            else { return [] }
            return body.map {
                .init(
                    value: $0.id,
                    label: $0.name ?? $0.id,
                    isSelected: selected.contains($0.id)
                )
            }
        }

        private func updateResponse(
            request: Request,
            context: AuthenticatedRequestContext,
            id: String,
            presenter: any Invitation.Edit.Presenter.Interface,
            state: Invitation.Form.Component.State
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
}
