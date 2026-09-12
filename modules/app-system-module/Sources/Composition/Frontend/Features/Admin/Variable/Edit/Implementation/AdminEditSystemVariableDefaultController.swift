import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import SystemContracts

struct AdminEditSystemVariableDefaultController:
    AdminEditSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditSystemVariableInteractor,
            presenter: any AdminEditSystemVariablePresenter
        )

    func getEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
        else {
            throw HTTPError(.forbidden)
        }
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = permissionKeys(context.currentUserPermissions)
        do {
            let variable = try await runtime.interactor.load(id: id)
            return try await runtime.presenter.renderEditPage(
                id: id,
                state: .from(variable: variable),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
        catch {
            return try await runtime.presenter.renderErrorPage(
                info: "Unable to load system variable.",
                message: error.displayMessage
            )
        }
    }

    func postEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
        else {
            throw HTTPError(.forbidden)
        }
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = permissionKeys(context.currentUserPermissions)
        var lastPayload: SystemVariableEditFormInput?

        do {
            let payload = try await request.decode(
                as: SystemVariableEditFormInput.self,
                context: context
            )
            lastPayload = payload
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                throw HTTPError(.forbidden)
            }
            try await runtime.interactor.edit(id: id, input: payload)

            return AdminNotificationFlash.redirect(
                to: SystemVariableRoutes.edit(RouterPath(id))
                    .description,
                notification: .init(
                    title: "Saved",
                    message: "System variable edited successfully."
                )
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = formState(input: lastPayload)
            state.apply(errors: errors)
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as HTTPError {
            throw error
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(input: lastPayload)
            state.apply(error: error.errorDescription)
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(input: lastPayload)
            state.apply(error: error.displayMessage)
            return try await runtime.presenter
                .renderEditPage(
                    id: id,
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        input: SystemVariableEditFormInput?
    ) -> SystemVariableEditForm.State {
        input.map { SystemVariableEditForm.State.from(input: $0) } ?? .empty()
    }

    private func permissionKeys(_ permissions: Set<String>) -> Set<
        PermissionKey
    > {
        Set(permissions.map(PermissionKey.init))
    }
}
