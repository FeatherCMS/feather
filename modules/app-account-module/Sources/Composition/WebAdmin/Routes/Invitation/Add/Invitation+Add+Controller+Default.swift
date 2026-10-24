import AccountModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Add.Controller {

    struct Default:
        Invitation.Add.Controller.Interface
    {
        let environment: AppEnvironment
        let routes: Invitation.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Invitation.Add.Interactor.Interface,
                any Invitation.Add.Presenter.Interface
            >

        func getAddAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let presenter = buildRuntime(request, context).presenter
            return try await presenter.renderPage(
                form: presenter.formState(
                    email: "",
                    roleIDs: [],
                    roleOptions: await roleOptions(context)
                ),
                permissions: context.currentUserPermissions
            )
        }

        func postAddAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            var lastPayload: Invitation.Add.Form.Input?
            let availableRoleOptions = await roleOptions(context)
            do {
                let nonceRequest = try await request.decode(
                    as: NonceRequest<Invitation.Add.Form.Input>.self,
                    context: context
                )
                guard
                    await AdminNonceStore.shared.consume(
                        nonceRequest.nonce,
                        sessionToken: context.sessionToken
                    )
                else {
                    var state = runtime.presenter.formState(
                        email: "",
                        roleIDs: [],
                        roleOptions: availableRoleOptions
                    )
                    state.error =
                        "This form has expired. Please reload the page."
                    return try await createResponse(
                        request: request,
                        context: context,
                        presenter: runtime.presenter,
                        state: state
                    )
                }
                let payload = nonceRequest.input
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.execute(
                    entity: .init(
                        email: payload.normalizedEmail,
                        roleIDs: payload.normalizedRoleIDs
                    )
                )
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.invitations.path + "/",
                            title: "Added",
                            message: "User invitation added successfully."
                        )
                    ]
                )
            }
            catch let error as ValidationError {
                var errs: [String: String] = [:]
                for f in error.failures { errs[f.key] = f.message }
                var state = runtime.presenter.formState(
                    email: lastPayload?.normalizedEmail ?? "",
                    roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                    roleOptions: availableRoleOptions
                )
                state.apply(errors: errs)
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: runtime.presenter,
                    state: state
                )
            }
            catch let error as OpenAPIRepositoryError {
                var state = runtime.presenter.formState(
                    email: lastPayload?.normalizedEmail ?? "",
                    roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                    roleOptions: availableRoleOptions
                )
                state.error = runtime.presenter.format(error: error)
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: runtime.presenter,
                    state: state
                )
            }
            catch {
                var state = runtime.presenter.formState(
                    email: lastPayload?.normalizedEmail ?? "",
                    roleIDs: lastPayload?.normalizedRoleIDs ?? [],
                    roleOptions: availableRoleOptions
                )
                state.error = error.displayMessage
                return try await createResponse(
                    request: request,
                    context: context,
                    presenter: runtime.presenter,
                    state: state
                )
            }
        }

        private func roleOptions(
            _ context: AuthenticatedRequestContext
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
                .init(value: $0.id, label: $0.name ?? $0.id, isSelected: false)
            }
        }

        private func createResponse(
            request: Request,
            context: AuthenticatedRequestContext,
            presenter: any Invitation.Add.Presenter.Interface,
            state: Invitation.Form.Component.State
        ) async throws -> Response {
            try await presenter.renderPage(
                form: state,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
