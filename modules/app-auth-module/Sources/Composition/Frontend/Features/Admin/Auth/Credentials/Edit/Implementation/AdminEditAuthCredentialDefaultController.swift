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
import WebStandards

struct AdminEditAuthCredentialDefaultController:
    AdminEditAuthCredentialController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAuthCredentialInteractor,
            presenter: any AdminEditAuthCredentialPresenter
        )

    func getEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        do {
            let credential = try await interactor.get(id: id)
            return presenter.renderPage(
                id: id,
                form: presenter.formState(
                    email: credential.email,
                    password: ""
                ),
                permissions: context.currentUserPermissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(
                id: id,
                error: error,
                permissions: context.currentUserPermissions
            )
        }
    }

    func postEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        var payload: AdminAuthCredentialFormInput?
        do {
            payload = try await request.decode(
                as: AdminAuthCredentialFormInput.self,
                context: context
            )
            try await payload!.validate(requiredPassword: false)
            try await interactor.execute(
                id: id,
                payload: .init(
                    email: payload!.normalizedEmail,
                    password: payload!.normalizedPassword,
                    isPersistent: nil
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/credentials/\(id)/edit/",
                        title: "Saved",
                        message: "User credential edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var state = presenter.formState(
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.apply(
                errors: Dictionary(
                    uniqueKeysWithValues: error.failures.map {
                        ($0.key, $0.message)
                    }
                )
            )
            return
                try presenter.renderPage(
                    id: id,
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = presenter.format(error: error)
            return
                try presenter.renderPage(
                    id: id,
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = presenter.formState(
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = error.displayMessage
            return
                try presenter.renderPage(
                    id: id,
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
