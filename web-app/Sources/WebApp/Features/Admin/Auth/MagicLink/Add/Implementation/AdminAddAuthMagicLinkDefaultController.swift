import FeatherValidation
import Hummingbird

struct AdminAddAuthMagicLinkDefaultController: AdminAddAuthMagicLinkController {

    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddAuthMagicLinkInteractor,
            presenter: any AdminAddAuthMagicLinkPresenter
        )

    func getAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            form: presenter.formState(
                email: "",
                isPersistent: false
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        var lastPayload: AdminAddAuthMagicLinkFormInput?
        do {
            let payload = try await request.decode(
                as: AdminAddAuthMagicLinkFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    email: payload.normalizedEmail,
                    isPersistent: payload.isPersistent.value
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/magic-links/",
                        title: "Added",
                        message: "User magic link added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.apply(errors: errs)
            return try createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = presenter.format(error: error)
            return try createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
        catch {
            var state = presenter.formState(
                email: lastPayload?.normalizedEmail ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
            )
            state.error = error.displayMessage
            return try createResponse(
                request: request,
                context: context,
                presenter: presenter,
                state: state
            )
        }
    }

    private func createResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminAddAuthMagicLinkPresenter,
        state: AuthMagicLinkForm.State
    ) throws -> Response {
        try presenter.renderPage(
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
