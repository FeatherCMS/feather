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
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions.granted
        do {
            let variable = try await runtime.interactor.load(id: id)
            return try await runtime.presenter.renderEditPage(
                id: id,
                state: .from(variable: variable),
                permissions: permissions
            )
        }
        catch let error as AdminEditSystemVariableError {
            return try await runtime.presenter.renderErrorPage(
                error: error
            )
        }
    }

    func postEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.update)
        else {
            return try await runtime.presenter
                .renderErrorPage(
                    error: .forbidden
                )
                .response(from: request, context: context)
        }
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions.granted
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
                to: SystemVariableRoutes.edit(RouterPath(id)).description,
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
        catch let error as AdminEditSystemVariableError {
            var state = formState(input: lastPayload)

            switch error {
            case .notFound:
                state.apply(error: "This system variable no longer exists.")
            case .unauthorized:
                throw HTTPError(.unauthorized)
            case .forbidden:
                throw HTTPError(.forbidden)
            case .conflict:
                state.apply(
                    error: "A system variable with this key already exists."
                )
            case .unavailable:
                state.apply(
                    error: "The system variable could not be saved. Please try again."
                )
            }

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

}
