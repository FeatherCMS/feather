import FeatherValidation
import Hummingbird

struct AdminAddAuthCredentialDefaultController: AdminAddAuthCredentialController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (
        interactor: any AdminAddAuthCredentialInteractor,
        presenter: any AdminAddAuthCredentialPresenter
    )

    func getAddCredential(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let accountID = try context.requiredID()
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            accountID: accountID,
            form: presenter.formState(email: "", password: ""),
            permissions: context.currentUserPermissions
        )
    }

    func postAddCredential(request: Request, context: AppRequestContext) async throws -> Response {
        let accountID = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        var payload: AdminAuthCredentialFormInput?
        do {
            payload = try await request.decode(as: AdminAuthCredentialFormInput.self, context: context)
            try await payload!.validate(requiredPassword: true)
            try await interactor.execute(
                accountID: accountID,
                payload: .init(email: payload!.normalizedEmail, password: payload!.normalizedPassword)
            )
            return Response(status: .seeOther, headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/auth/credentials/\(accountID)/",
                    title: "Added",
                    message: "User credential added successfully."
                )
            ])
        }
        catch let error as ValidationError {
            var state = presenter.formState(email: payload?.normalizedEmail ?? "", password: "")
            state.apply(errors: Dictionary(uniqueKeysWithValues: error.failures.map { ($0.key, $0.message) }))
            return try presenter.renderPage(accountID: accountID, form: state, permissions: context.currentUserPermissions)
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(email: payload?.normalizedEmail ?? "", password: "")
            state.error = presenter.format(error: error)
            return try presenter.renderPage(accountID: accountID, form: state, permissions: context.currentUserPermissions)
                .response(from: request, context: context)
        }
        catch {
            var state = presenter.formState(email: payload?.normalizedEmail ?? "", password: "")
            state.error = error.displayMessage
            return try presenter.renderPage(accountID: accountID, form: state, permissions: context.currentUserPermissions)
                .response(from: request, context: context)
        }
    }
}
