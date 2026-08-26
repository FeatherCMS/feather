import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminAddWebMenuItemDefaultController: AdminAddWebMenuItemController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddWebMenuItemInteractor,
            presenter: any AdminAddWebMenuItemPresenter
        )

    func getAddWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        do {
            let availablePermissions = try await runtime.interactor
                .loadPermissions()
            return runtime.presenter.renderAddPage(
                menuId: menuId,
                state: formState(permissionOptions: availablePermissions),
                permissions: context.currentUserPermissions
            )
        }
        catch {
            var state = formState()
            state.error = error.displayMessage
            return runtime.presenter.renderAddPage(
                menuId: menuId,
                state: state,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postAddWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let permissions = context.currentUserPermissions
        var lastPayload: WebMenuItemFormInput?
        var availablePermissions: [String] = []

        do {
            let payload = try await request.decode(
                as: WebMenuItemFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()

            var permissionLoadError: String?
            do {
                availablePermissions = try await runtime.interactor
                    .loadPermissions()
            }
            catch {
                permissionLoadError = error.displayMessage
            }

            if let permissionLoadError,
                !payload.permission.isEmpty
            {
                var state = formState(
                    label: payload.normalizedLabel,
                    url: payload.normalizedURL,
                    priority: payload.normalizedPriority,
                    isBlank: payload.isBlank.value,
                    permission: payload.permission,
                    permissionOptions: availablePermissions,
                    authentication: payload.normalizedAuthentication,
                    notes: payload.normalizedNotes
                )
                state.error = permissionLoadError
                return try runtime.presenter
                    .renderAddPage(
                        menuId: menuId,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            if permissionLoadError == nil,
                !payload.hasValidPermission(
                    availablePermissions: Set(availablePermissions)
                )
            {
                var state = formState(
                    label: payload.normalizedLabel,
                    url: payload.normalizedURL,
                    priority: payload.normalizedPriority,
                    isBlank: payload.isBlank.value,
                    permission: payload.permission,
                    permissionOptions: availablePermissions,
                    authentication: payload.normalizedAuthentication,
                    notes: payload.normalizedNotes
                )
                state.apply(errors: [
                    "permission": "Select a valid permission."
                ])
                return try runtime.presenter
                    .renderAddPage(
                        menuId: menuId,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            guard payload.parsedPriority != nil else {
                var state = formState(
                    label: payload.normalizedLabel,
                    url: payload.normalizedURL,
                    priority: payload.normalizedPriority,
                    isBlank: payload.isBlank.value,
                    permission: payload.permission,
                    permissionOptions: availablePermissions,
                    authentication: payload.normalizedAuthentication,
                    notes: payload.normalizedNotes
                )
                state.apply(errors: [
                    "priority": "Priority must be a valid integer."
                ])
                return try runtime.presenter
                    .renderAddPage(
                        menuId: menuId,
                        state: state,
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }
            try await runtime.interactor.execute(menuId: menuId, input: payload)

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/web/menus/\(menuId)/edit/",
                        title: "Added",
                        message: "Item added successfully."
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
                permission: lastPayload?.permission ?? "",
                permissionOptions: availablePermissions,
                authentication: lastPayload?.normalizedAuthentication ?? "any",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errors)
            return try runtime.presenter
                .renderAddPage(
                    menuId: menuId,
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
                permission: lastPayload?.permission ?? "",
                permissionOptions: availablePermissions,
                authentication: lastPayload?.normalizedAuthentication ?? "any",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.errorDescription
            return try runtime.presenter
                .renderAddPage(
                    menuId: menuId,
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
                permission: lastPayload?.permission ?? "",
                permissionOptions: availablePermissions,
                authentication: lastPayload?.normalizedAuthentication ?? "any",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return try runtime.presenter
                .renderAddPage(
                    menuId: menuId,
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
        permissionOptions: [String] = [],
        authentication: String = "any",
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
            permissionOptions: permissionOptions,
            authentication: .init(
                key: "authentication",
                label: "Visible to",
                value: authentication,
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
