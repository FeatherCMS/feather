import FeatherValidation
import HTML
import Hummingbird

struct AdminEditWebMenuDefaultController:
    AdminEditWebMenuController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebMenuInteractor,
            presenter: any AdminEditWebMenuPresenter
        )

    func getEditWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions

        do {
            let menu = try await runtime.interactor.load(id: id)
            return runtime.presenter.renderEditPage(
                id: id,
                state: formState(
                    key: menu.key,
                    name: menu.name,
                    notes: menu.notes
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

    func postEditWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: WebMenuFormInput?

        do {
            let payload = try await request.decode(
                as: WebMenuFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.update(id: id, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/menus/\(id)/edit/",
                        title: "Saved",
                        message: "Menu edited successfully."
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
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
        key: String = "",
        name: String = "",
        notes: String = ""
    ) -> WebMenuForm.State {
        .init(
            key: .init(key: "key", label: "Key", value: key, error: nil),
            name: .init(key: "name", label: "Name", value: name, error: nil),
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
