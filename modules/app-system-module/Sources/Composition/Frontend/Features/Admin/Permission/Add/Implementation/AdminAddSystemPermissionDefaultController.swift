import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemContracts

struct AdminAddSystemPermissionDefaultController:
    AdminAddSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddSystemPermissionInteractor,
            presenter: any AdminAddSystemPermissionPresenter
        )

    func getAddSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: SystemPermissions.Permissions.create) else {
            return try await presenter.renderErrorPage(
                info: "Forbidden",
                message: "Your account cannot create system permissions."
            )
        }
        return try await presenter.renderAddPage(state: formState())
    }

    func postAddSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: SystemPermissions.Permissions.create) else {
            return try await presenter.renderErrorPage(
                info: "Forbidden",
                message: "Your account cannot create system permissions."
            ).response(from: request, context: context)
        }
        var lastPayload: SystemPermissionAddFormInput?

        do {
            let payload = try await request.decode(
                as: SystemPermissionAddFormInput.self,
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

            try await interactor.execute(
                entity: .init(
                    key: payload.normalizedKey,
                    name: payload.normalizedName,
                    notes: payload.normalizedNotes
                )
            )

            return AdminNotificationFlash.redirect(
                to: SystemPermissionRoutes.list.description,
                notification: .init(
                    title: "Added",
                    message: "System permission added successfully."
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
            return
                try await presenter
                .renderAddPage(
                    state: state,
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
            return
                try await presenter
                .renderAddPage(
                    state: state,
                )
                .response(from: request, context: context)
        }
        catch let error as HTTPError {
            return try await presenter.renderErrorPage(
                info: "Unable to create system permission.",
                message: error.displayMessage
            ).response(from: request, context: context)
        }
        catch {
            var state = formState(
                key: lastPayload?.normalizedKey ?? "",
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return
                try await presenter
                .renderAddPage(
                    state: state,
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        key: String = "",
        name: String = "",
        notes: String = ""
    ) -> SystemPermissionAddForm.State {
        .init(
            key: .init(name: "key", label: "Key", value: key, isRequired: true),
            name: .init(name: "name", label: "Name", value: name),
            notes: .init(name: "notes", label: "Notes", value: notes, style: .small),
            error: nil
        )
    }
}
