import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemContracts

struct AdminEditSystemPermissionDefaultController:
    AdminEditSystemPermissionController
{
    let buildRuntime:
        RuntimeBuilder<
            any AdminEditSystemPermissionInteractor,
            any AdminEditSystemPermissionPresenter
        >

    func getEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        guard
            context.isCurrentUserAllowed(
                to: SystemPermissions.Permissions.update
            )
        else {
            return try await presenter.renderErrorPage(error: .forbidden)
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
        catch let error as AdminEditSystemPermissionError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

    func postEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        guard
            context.isCurrentUserAllowed(
                to: SystemPermissions.Permissions.update
            )
        else {
            return
                try await presenter.renderErrorPage(error: .forbidden)
                .response(from: request, context: context)
        }
        var lastPayload: SystemPermissionEditFormInput?
        do {
            let payload = try await request.decode(
                as: NonceRequest<SystemPermissionEditFormInput>.self,
                context: context
            )
            lastPayload = payload.input
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return
                    try await presenter.renderInvalidNoncePage()
                    .response(from: request, context: context)
            }
            try await payload.input.validate()
            try await interactor.update(id: id, input: payload.input)
            return presenter.renderSuccess(id: id)
        }
        catch let error as ValidationError {
            return
                try await presenter.renderValidationError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
        catch let error as AdminEditSystemPermissionError {
            return
                try await presenter.renderEditError(
                    id: id,
                    input: lastPayload,
                    error: error
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        key: String,
        name: String,
        notes: String
    ) -> SystemPermissionEditForm.State {
        .init(
            key: .init(name: "key", label: "Key", value: key, isRequired: true),
            name: .init(name: "name", label: "Name", value: name),
            notes: .init(
                name: "notes",
                label: "Notes",
                value: notes,
                style: .small
            ),
            error: nil
        )
    }
}
