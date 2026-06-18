import FeatherValidation
import HTML
import Hummingbird

struct AdminAddUserRoleDefaultController: AdminAddUserRoleController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddUserRoleInteractor,
            presenter: any AdminAddUserRolePresenter
        )

    func getAddUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(name: "", notes: ""),
            permissions: context.currentUserPermissions
        )
    }

    func postAddUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        var lastPayload: AdminAddUserRoleFormInput?
        do {
            let payload = try await request.decode(
                as: AdminAddUserRoleFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await runtime.interactor.execute(
                entity: .init(
                    name: payload.normalizedName,
                    notes: payload.normalizedNotes
                ),
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/user/roles/",
                        title: "Added",
                        message: "User role added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = runtime.presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.apply(errors: errs)
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = runtime.presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = runtime.presenter.format(error: error)
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
        catch {
            var state = runtime.presenter.formState(
                name: lastPayload?.normalizedName ?? "",
                notes: lastPayload?.normalizedNotes ?? ""
            )
            state.error = error.displayMessage
            return try createResponse(
                request: request,
                context: context,
                presenter: runtime.presenter,
                state: state
            )
        }
    }

    private func createResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminAddUserRolePresenter,
        state: UserRoleForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
