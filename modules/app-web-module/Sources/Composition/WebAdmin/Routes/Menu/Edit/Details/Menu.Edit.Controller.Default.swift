import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Edit.Controller {
    struct Default: Interface {
        let routes: WebModule.Menu.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any WebModule.Menu.Edit.Interactor.Interface,
                any WebModule.Menu.Edit.Presenter.Interface
            >

        func getEditMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            do {
                let menu = try await runtime.interactor.load(id: id)
                return try await runtime.presenter.renderEditPage(
                    id: id,
                    state: formState(
                        key: menu.key,
                        name: menu.name,
                        notes: menu.notes
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }

        func postEditMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredID()
            let permissions = context.currentUserPermissions
            var lastPayload: WebModule.Menu.Form.Input?

            do {
                let payload = try await request.decode(
                    as: WebModule.Menu.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.update(id: id, input: payload)

                return AdminNotification.redirect(
                    to: routes.editPath(id),
                    notification: .init(
                        title: "Saved",
                        message: "Menu edited successfully."
                    )
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
                return try await runtime.presenter
                    .renderEditPage(
                        id: id,
                        state: state,
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
                return try await runtime.presenter
                    .renderEditPage(
                        id: id,
                        state: state,
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
            key: String = "",
            name: String = "",
            notes: String? = nil
        ) -> WebModule.Menu.Form.Component.State {
            .init(
                key: .init(key: "key", label: "Key", value: key, error: nil),
                name: .init(
                    key: "name",
                    label: "Name",
                    value: name,
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
}
