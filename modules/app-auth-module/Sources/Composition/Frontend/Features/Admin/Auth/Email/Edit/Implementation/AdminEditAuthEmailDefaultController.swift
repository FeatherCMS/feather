import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminEditAuthEmailDefaultController: AdminEditAuthEmailController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAuthEmailInteractor,
            presenter: any AdminEditAuthEmailPresenter
        )

    func getEditAuthEmail(
        request: Request,
        context: DefaultRequestContext
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
            let identities = (try? await interactor.listIdentities()) ?? []
            return presenter.renderPage(
                id: id,
                isEdited: isEdited,
                form: presenter.formState(
                    identityId: link.identityId,
                    identities: identities,
                    email: link.email
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

    func postEditAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        var lastPayload: AdminEditAuthEmailFormInput?
        do {
            let payload = try await request.decode(
                as: AdminEditAuthEmailFormInput.self,
                context: context
            )
            lastPayload = payload
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: id,
                    identityId: payload.normalizedIdentityId,
                    email: payload.normalizedEmail
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/emails/\(id)/edit/",
                        title: "Saved",
                        message: "User email edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var errs: [String: String] = [:]
            for f in error.failures { errs[f.key] = f.message }
            var state = presenter.formState(
                identityId: lastPayload?.normalizedIdentityId ?? "",
                email: lastPayload?.normalizedEmail ?? ""
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
                identityId: lastPayload?.normalizedIdentityId ?? "",
                email: lastPayload?.normalizedEmail ?? ""
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
                identityId: lastPayload?.normalizedIdentityId ?? "",
                email: lastPayload?.normalizedEmail ?? ""
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
        context: DefaultRequestContext,
        id: String,
        presenter: any AdminEditAuthEmailPresenter,
        state: AuthEmailForm.State
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
