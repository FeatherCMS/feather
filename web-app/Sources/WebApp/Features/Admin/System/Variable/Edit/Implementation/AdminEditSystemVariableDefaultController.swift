import FeatherValidation
import HTML
import Hummingbird

struct AdminEditSystemVariableDefaultController:
    AdminEditSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditSystemVariableInteractor,
            presenter: any AdminEditSystemVariablePresenter
        )

    func getEditSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let variable = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    name: variable.name,
                    value: variable.value,
                    notes: variable.notes
                ),
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: SystemVariableFormInput?

        do {
            let payload = try await request.decode(
                as: SystemVariableFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/system/variables/\(id)/edit/",
                        title: "Saved",
                        message: "System variable edited successfully."
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
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
                .renderEditPage(
                    id: id,
                    state: state,
                    isEdited: false,
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
