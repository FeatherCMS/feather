import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.Edit.Controller {
    struct Default:
        Interface
    {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Permission.Edit.Interactor.Interface,
                any Permission.Edit.Presenter.Interface
            >

        func getEditSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let id = try context.requiredID()
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.update
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
            catch let error
                as Permission.Edit.Error
            {
                return try await presenter.renderErrorPage(error: error)
            }
        }

        func postEditSystemPermission(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let id = try context.requiredID()
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Permission.Permissions.update
                )
            else {
                return
                    try await presenter.renderErrorPage(error: .forbidden)
                    .response(from: request, context: context)
            }
            var lastPayload: Permission.Edit.Form.Input?
            do {
                let payload = try await request.decode(
                    as: NonceRequest<Permission.Edit.Form.Input>.self,
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
                return presenter.renderSuccess(id: payload.input.normalizedKey)
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
            catch let error
                as Permission.Edit.Error
            {
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
        ) -> Permission.Edit.Form.State {
            .init(
                key: .init(
                    name: "key",
                    label: "Key",
                    value: key,
                    isRequired: true
                ),
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
}
