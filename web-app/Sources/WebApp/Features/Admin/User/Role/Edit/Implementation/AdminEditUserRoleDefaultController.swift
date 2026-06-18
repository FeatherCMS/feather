import FeatherValidation
import HTML
import Hummingbird

struct AdminEditUserRoleDefaultController: AdminEditUserRoleController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditUserRoleInteractor,
            presenter: any AdminEditUserRolePresenter
        )

    func getEditUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let isEdited = request.hasQueryFlag("edited")
        let permissions = context.currentUserPermissions
        do {
            let role = try await interactor.get(id: id)
            return presenter.renderEditPage(
                id: id,
                state: presenter.formState(
                    name: role.name,
                    notes: role.notes
                ),
                isEdited: isEdited,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderErrorPage(
                id: id,
                info: error.errorTitle,
                message: error.errorDescription,
                permissions: permissions
            )
        }
    }

    func postEditUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        var lastPayload: AdminEditUserRoleFormInput?
        do {
            let payload = try await request.decode(
                as: AdminEditUserRoleFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: id,
                    name: payload.normalizedName,
                    notes: payload.normalizedNotes
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/roles/\(id)/edit/",
                        title: "Saved",
                        message: "User role edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errs)
            return try updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = presenter.format(error: error)
            return try updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return try updateResponse(
                request: request,
                context: context,
                id: id,
                presenter: presenter,
                state: state
            )
        }
    }

    private func updateResponse(
        request: Request,
        context: AppRequestContext,
        id: String,
        presenter: any AdminEditUserRolePresenter,
        state: UserRoleForm.State
    ) throws -> Response {
        try presenter.renderEditPage(
            id: id,
            state: state,
            isEdited: false,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
