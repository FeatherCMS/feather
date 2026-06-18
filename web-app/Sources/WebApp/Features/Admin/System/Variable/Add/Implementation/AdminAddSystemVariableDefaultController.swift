import FeatherValidation
import HTML
import Hummingbird

struct AdminAddSystemVariableDefaultController: AdminAddSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddSystemVariableInteractor,
            presenter: any AdminAddSystemVariablePresenter
        )

    func getAddSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        return runtime.presenter.renderAddPage(
            state: formState(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: SystemVariableFormInput?

        do {
            let payload = try await request.decode(
                as: SystemVariableFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/system/variables/",
                        title: "Added",
                        message: "System variable added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            var state = formState(
                name: lastPayload?.normalizedName ?? "",
                value: lastPayload?.normalizedValue ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(
                name: lastPayload?.normalizedName ?? "",
                value: lastPayload?.normalizedValue ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(
                name: lastPayload?.normalizedName ?? "",
                value: lastPayload?.normalizedValue ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        name: String = "",
        value: String = "",
        notes: String = ""
    ) -> SystemVariableForm.State {
        .init(
            name: .init(key: "name", label: "Name", value: name, error: nil),
            value: .init(
                key: "value",
                label: "Value",
                value: value,
                error: nil
            ),
            notes: .init(
                key: "notes",
                label: "Notes",
                value: notes,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }
}
