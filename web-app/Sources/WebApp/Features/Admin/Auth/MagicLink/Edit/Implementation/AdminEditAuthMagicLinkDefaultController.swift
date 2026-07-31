import FeatherValidation
import Hummingbird

struct AdminEditAuthMagicLinkDefaultController: AdminEditAuthMagicLinkController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditAuthMagicLinkInteractor,
            presenter: any AdminEditAuthMagicLinkPresenter
        )

    func getEditAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let id = try context.requiredID()
        let isEdited = request.hasQueryFlag("edited")
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        let permissions = context.currentUserPermissions
        do {
            let link = try await interactor.get(id: id)
            return presenter.renderPage(
                id: id,
                isEdited: isEdited,
                form: presenter.formState(
                    email: link.email,
                    isPersistent: link.isPersistent
                ),
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                id: id,
                error: error,
                permissions: permissions
            )
        }
    }

    func postEditAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        var lastPayload: AdminEditAuthMagicLinkFormInput?
        do {
            let payload = try await request.decode(
                as: AdminEditAuthMagicLinkFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: id,
                    email: payload.normalizedEmail,
                    isPersistent: payload.isPersistent.value
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/magic-links/\(id)/edit/",
                        title: "Saved",
                        message: "User magic link edited successfully."
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
                email: lastPayload?.normalizedEmail ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
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
                email: lastPayload?.normalizedEmail ?? "",
                isPersistent: lastPayload?.isPersistent.value ?? false
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
        presenter: any AdminEditAuthMagicLinkPresenter,
        state: AuthMagicLinkForm.State
    ) throws -> Response {
        try presenter.renderPage(
            id: id,
            isEdited: false,
            form: state,
            permissions: context.currentUserPermissions
        )
        .response(from: request, context: context)
    }
}
