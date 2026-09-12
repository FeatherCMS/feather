import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Hummingbird
import SystemContracts

struct AdminEditSystemPermissionDefaultController:
    AdminEditSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditSystemPermissionInteractor,
            presenter: any AdminEditSystemPermissionPresenter
        )

    func getEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        guard context.isCurrentUserAllowed(to: SystemPermissions.Permissions.update) else {
            return try await presenter.renderErrorPage(
                info: "Forbidden",
                message: "Your account cannot edit system permissions."
            )
        }
        do {
            let permission = try await interactor.load(id: id)
            return try await presenter.renderEditPage(
                id: id,
                state: formState(
                    key: permission.key,
                    name: permission.name ?? "",
                    notes: permission.notes ?? ""
                ),
                isEdited: request.hasQueryFlag("edited")
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderErrorPage(
                info: error.errorTitle,
                message: error.errorDescription
            )
        }
        catch {
            return try await presenter.renderErrorPage(
                info: "Unable to load system permission.",
                message: error.displayMessage
            )
        }
    }

    func postEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        guard context.isCurrentUserAllowed(to: SystemPermissions.Permissions.update) else {
            return try await presenter.renderErrorPage(
                info: "Forbidden",
                message: "Your account cannot edit system permissions."
            ).response(from: request, context: context)
        }
        var lastPayload: SystemPermissionEditFormInput?
        do {
            let payload = try await request.decode(
                as: SystemPermissionEditFormInput.self,
                context: context
            )
            lastPayload = payload
            guard await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            ) else {
                return try await presenter.renderErrorPage(
                    info: "Forbidden",
                    message: "This form has expired. Please try again."
                ).response(from: request, context: context)
            }
            try await payload.validate()
            try await interactor.update(id: id, input: payload)
            return AdminNotificationFlash.redirect(
                to: SystemPermissionRoutes.edit(RouterPath(id)).description,
                notification: .init(
                    title: "Saved",
                    message: "System permission edited successfully."
                )
            )
        }
        catch let error as ValidationError {
            var state = formState(input: lastPayload)
            state.apply(errors: Dictionary(
                uniqueKeysWithValues: error.failures.map { ($0.key, $0.message) }
            ))
            return try await presenter.renderEditPage(
                id: id,
                state: state,
                isEdited: false
            ).response(from: request, context: context)
        }
        catch let error as HTTPError {
            return try await presenter.renderErrorPage(
                info: "Unable to update system permission.",
                message: error.displayMessage
            ).response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(input: lastPayload)
            state.error = error.errorDescription
            return try await presenter.renderEditPage(
                id: id,
                state: state,
                isEdited: false
            ).response(from: request, context: context)
        }
        catch {
            var state = formState(input: lastPayload)
            state.error = error.displayMessage
            return try await presenter.renderEditPage(
                id: id,
                state: state,
                isEdited: false
            ).response(from: request, context: context)
        }
    }

    private func formState(key: String = "", name: String = "", notes: String = "") -> SystemPermissionEditForm.State {
        .init(
            key: .init(name: "key", label: "Key", value: key, isRequired: true),
            name: .init(name: "name", label: "Name", value: name),
            notes: .init(name: "notes", label: "Notes", value: notes, style: .small),
            error: nil
        )
    }

    private func formState(input: SystemPermissionEditFormInput?) -> SystemPermissionEditForm.State {
        formState(
            key: input?.normalizedKey ?? "",
            name: input?.normalizedName ?? "",
            notes: input?.normalizedNotes ?? ""
        )
    }
}
