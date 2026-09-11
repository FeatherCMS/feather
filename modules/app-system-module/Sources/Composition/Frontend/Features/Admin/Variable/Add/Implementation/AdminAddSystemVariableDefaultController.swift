import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import SystemContracts

struct AdminAddSystemVariableDefaultController: AdminAddSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddSystemVariableInteractor,
            presenter: any AdminAddSystemVariablePresenter
        )

    func getAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.create)
        else {
            throw HTTPError(.forbidden)
        }
        let runtime = buildRuntime(request, context)
        return try await runtime.presenter.renderAddPage(
            state: .empty()
        )
    }

    func postAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        guard
            context.isCurrentUserAllowed(to: SystemPermissions.Variables.create)
        else {
            throw HTTPError(.forbidden)
        }
        let runtime = buildRuntime(request, context)
        var lastPayload: SystemVariableAddFormInput?

        do {
            let payload = try await request.decode(
                as: SystemVariableAddFormInput.self,
                context: context
            )
            lastPayload = payload
            guard await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            ) else {
                throw HTTPError(.forbidden)
            }
            try await runtime.interactor.add(input: payload)

            return AdminNotificationFlash.redirect(
                to: SystemVariableRoutes.list.description,
                notification: .init(
                    title: "Added",
                    message: "System variable added successfully."
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
                .renderAddPage(state: state)
                .response(from: request, context: context)
        }
        catch let error as HTTPError {
            throw error
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(input: lastPayload)
            state.apply(error: error.errorDescription)
            return try await runtime.presenter
                .renderAddPage(state: state)
                .response(from: request, context: context)
        }
        catch {
            var state = formState(input: lastPayload)
            state.apply(error: error.displayMessage)
            return try await runtime.presenter
                .renderAddPage(state: state)
                .response(from: request, context: context)
        }
    }

    private func formState(
        input: SystemVariableAddFormInput?
    ) -> SystemVariableAddForm.State {
        input.map { SystemVariableAddForm.State.from(input: $0) } ?? .empty()
    }

}
