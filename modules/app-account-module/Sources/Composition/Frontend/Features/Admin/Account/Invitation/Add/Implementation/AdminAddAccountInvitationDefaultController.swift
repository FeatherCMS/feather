import FeatherAdmin
import FeatherValidation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminAddAccountInvitationDefaultController:
    AdminAddAccountInvitationController
{
    let apiBuilder: AccountAPIBuilder
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddAccountInvitationInteractor,
            any AdminAddAccountInvitationPresenter
        >

    func getAddAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime((request, context))
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
        let runtime = buildRuntime((request, context))
        var lastPayload: AdminAddAccountInvitationFormInput?
        let availableRoleOptions = await roleOptions(context)
        do {
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminAddAccountInvitationFormInput>.self,
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
                state.error = "This form has expired. Please reload the page."
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
            let (interactor, _) = runtime
            try await interactor.execute(
                entity: .init(
                    email: payload.normalizedEmail,
                    roleIDs: payload.normalizedRoleIDs
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/account/invitations/",
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
    ) async -> [AccountInvitationForm.RoleOptionState] {
        let userAPI = apiBuilder.makeUserAdmin(context)
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
            .init(value: $0.id, label: $0.name ?? $0.id, isSelected: false)
        }
    }

    private func createResponse(
        request: Request,
        context: AuthenticatedRequestContext,
        presenter: any AdminAddAccountInvitationPresenter,
        state: AccountInvitationForm.State
    ) async throws -> Response {
        try await presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
