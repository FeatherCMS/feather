import FeatherValidation
import Hummingbird

struct AdminAddSystemPermissionDefaultController:
    AdminAddSystemPermissionController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddSystemPermissionInteractor,
            presenter: any AdminAddSystemPermissionPresenter
        )

    func getAddSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderAddPage(
            state: formState(),
            permissions: context.currentUserPermissions
        )
    }

    func postAddSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        var lastPayload: SystemPermissionFormInput?

        do {
            let payload = try await request.decode(
                as: SystemPermissionFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()

            try await interactor.execute(
                entity: .init(
                    name: payload.normalizedName,
                    notes: payload.normalizedNotes
                )
            )

            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/system/permissions/",
                        title: "Added",
                        message: "System permission added successfully."
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
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errors)
            return
                try presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.errorDescription
            return
                try presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return
                try presenter
                .renderAddPage(
                    state: state,
                    permissions: permissions
                )
                .response(from: request, context: context)
        }
    }

    private func formState(
        name: String = "",
        notes: String = ""
    ) -> SystemPermissionForm.State {
        .init(
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
