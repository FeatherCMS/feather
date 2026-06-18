import FeatherValidation
import HTML
import Hummingbird

struct AdminEditWebMenuItemDefaultController:
    AdminEditWebMenuItemController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditWebMenuItemInteractor,
            presenter: any AdminEditWebMenuItemPresenter
        )

    func getEditWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions

        do {
            let item = try await runtime.interactor.load(menuId: menuId, id: id)
            return runtime.presenter.renderEditPage(
                menuId: menuId,
                id: id,
                state: formState(
                    label: item.label,
                    url: item.url,
                    priority: "\(item.priority)",
                    isBlank: item.isBlank,
                    permission: item.permission,
                    notes: item.notes
                ),
                isEdited: request.hasQueryFlag("edited"),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderErrorPage(
                menuId: menuId,
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let id = try context.requiredParameter("itemId")
        let permissions = context.currentUserPermissions
        var lastPayload: WebMenuItemFormInput?

        do {
            let payload = try await request.decode(
                as: WebMenuItemFormInput.self,
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
                return try runtime.presenter
                    .renderEditPage(
                        menuId: menuId,
                        id: id,
                        state: state,
                        isEdited: false,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            try await runtime.interactor.update(
                menuId: menuId,
                id: id,
                input: payload
            )

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath:
                            "/admin/web/menus/\(menuId)/items/\(id)/edit/",
                        title: "Saved",
                        message: "Item edited successfully."
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
                label: lastPayload?.normalizedLabel ?? "",
                url: lastPayload?.normalizedURL ?? "",
                priority: lastPayload?.normalizedPriority ?? "0",
                isBlank: lastPayload?.isBlank.value ?? false,
                permission: lastPayload?.normalizedPermission ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderEditPage(
                    menuId: menuId,
                    id: id,
                    state: state,
                    isEdited: false,
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
            return try runtime.presenter
                .renderEditPage(
                    menuId: menuId,
                    id: id,
                    state: state,
                    isEdited: false,
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
            return try runtime.presenter
                .renderEditPage(
                    menuId: menuId,
                    id: id,
                    state: state,
                    isEdited: false,
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
    ) -> WebMenuItemForm.State {
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
            success: nil
        )
    }
}
