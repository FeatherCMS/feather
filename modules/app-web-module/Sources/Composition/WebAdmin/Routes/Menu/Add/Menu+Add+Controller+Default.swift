import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add.Controller {
    struct Default: Interface {
        let routes: WebModule.Menu.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any WebModule.Menu.Add.Interactor.Interface,
                any WebModule.Menu.Add.Presenter.Interface
            >

        func getAddMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            return try await runtime.presenter.renderAddPage(
                state: formState(),
                permissions: context.currentUserPermissions
            )
        }

        func postAddMenu(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let permissions = context.currentUserPermissions
            var lastPayload: WebModule.Menu.Form.Input?

            do {
                let payload = try await request.decode(
                    as: WebModule.Menu.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                try await runtime.interactor.execute(input: payload)

                return AdminNotificationFlash.redirect(
                    to: routes.list.path,
                    notification: .init(
                        title: "Added",
                        message: "Menu added successfully."
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
                    .renderAddPage(
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
                    .renderAddPage(
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
                    .renderAddPage(
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
        }

        private func formState(
            key: String = "",
            name: String = "",
            notes: String = ""
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
