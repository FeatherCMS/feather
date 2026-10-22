import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Edit.Controller {
    struct Default: Interface {
        let routes: AuthorLink.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any AuthorLink.Edit.Interactor.Interface,
                any AuthorLink.Edit.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let authorID = try context.requiredID()
            let id = try context.requiredParameter("itemId")
            let permissions = context.currentUserPermissions
            do {
                let item = try await runtime.interactor.load(
                    authorID: authorID,
                    id: id
                )
                return try await runtime.presenter.renderEditPage(
                    authorID: authorID,
                    id: id,
                    state: formState(
                        label: item.label,
                        url: item.url,
                        priority: "\(item.priority)",
                        isBlank: item.isBlank,
                        permission: item.permission,
                        notes: item.notes
                    ),
                    permissions: permissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    authorID: authorID,
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription,
                    permissions: permissions
                )
            }
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime((request, context))
            let authorID = try context.requiredID()
            let id = try context.requiredParameter("itemId")
            let permissions = context.currentUserPermissions
            var lastPayload: AuthorLink.Form.Input?

            do {
                let payload = try await request.decode(
                    as: AuthorLink.Form.Input.self,
                    context: context
                )
                lastPayload = payload
                try await payload.validate()
                guard payload.parsedPriority != nil else {
                    var state = formState(
                        label: payload.normalizedLabel,
                        url: payload.normalizedURL,
                        priority: payload.normalizedPriority,
                        isBlank: payload.isBlank.value,
                        permission: payload.normalizedPermission,
                        notes: payload.normalizedNotes
                    )
                    state.apply(errors: [
                        "priority": "Priority must be a valid integer."
                    ])
                    return try await runtime.presenter
                        .renderEditPage(
                            authorID: authorID,
                            id: id,
                            state: state,
                            permissions: permissions
                        )
                        .response(from: request, context: context)
                }
                try await runtime.interactor.update(
                    authorID: authorID,
                    id: id,
                    input: payload
                )

                return AdminNotificationFlash.redirect(
                    to:
                        routes.authorLinkEdit(
                            RouterPath(authorID),
                            RouterPath(id)
                        )
                        .description,
                    notification: .init(
                        title: "Saved",
                        message: "Blog author link updated successfully."
                    )
                )
            }
            catch let error as ValidationError {
                var errors: [String: String] = [:]
                for failure in error.failures {
                    errors[failure.key] = failure.message
                }
                var state = formState(
                    label: lastPayload?.normalizedLabel ?? "",
                    url: lastPayload?.normalizedURL ?? "",
                    priority: lastPayload?.normalizedPriority ?? "0",
                    isBlank: lastPayload?.isBlank.value ?? false,
                    permission: lastPayload?.normalizedPermission ?? "",
                    notes: lastPayload?.normalizedNotes ?? ""
                )
                state.apply(errors: errors)
                return try await runtime.presenter
                    .renderEditPage(
                        authorID: authorID,
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch let error as OpenAPIRepositoryError {
                var state = formState(
                    label: lastPayload?.normalizedLabel ?? "",
                    url: lastPayload?.normalizedURL ?? "",
                    priority: lastPayload?.normalizedPriority ?? "0",
                    isBlank: lastPayload?.isBlank.value ?? false,
                    permission: lastPayload?.normalizedPermission ?? "",
                    notes: lastPayload?.normalizedNotes ?? ""
                )
                state.error = error.errorDescription
                return try await runtime.presenter
                    .renderEditPage(
                        authorID: authorID,
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            catch {
                var state = formState(
                    label: lastPayload?.normalizedLabel ?? "",
                    url: lastPayload?.normalizedURL ?? "",
                    priority: lastPayload?.normalizedPriority ?? "0",
                    isBlank: lastPayload?.isBlank.value ?? false,
                    permission: lastPayload?.normalizedPermission ?? "",
                    notes: lastPayload?.normalizedNotes ?? ""
                )
                state.error = error.displayMessage
                return try await runtime.presenter
                    .renderEditPage(
                        authorID: authorID,
                        id: id,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
        }

        private func formState(
            label: String = "",
            url: String = "",
            priority: String = "0",
            isBlank: Bool = false,
            permission: String = "",
            notes: String = ""
        ) -> AuthorLink.Form.State {
            .init(
                label: .init(
                    key: "label",
                    label: "Label",
                    value: label,
                    error: nil
                ),
                url: .init(
                    key: "url",
                    label: "URL",
                    value: url,
                    error: nil
                ),
                priority: .init(
                    key: "priority",
                    label: "Priority",
                    value: priority,
                    error: nil
                ),
                isBlank: .init(
                    key: "isBlank",
                    label: "Open in new tab",
                    value: isBlank,
                    error: nil
                ),
                permission: .init(
                    key: "permission",
                    label: "Permission",
                    value: permission,
                    error: nil
                ),
                notes: .init(
                    key: "notes",
                    label: "Notes",
                    value: notes,
                    error: nil
                ),
                error: nil,
            )
        }
    }
}
