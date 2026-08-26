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

struct AdminAddAuthCredentialDefaultController: AdminAddAuthCredentialController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddAuthCredentialInteractor,
            presenter: any AdminAddAuthCredentialPresenter
        )

    func getAddCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    {
        let identityId = try context.requiredID()
        let (_, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            identityId: identityId,
            form: presenter.formState(email: "", password: ""),
            permissions: context.currentUserPermissions
        )
    }

    func postAddCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let identityId = try context.requiredID()
        let (interactor, presenter) = buildRuntime(request, context)
        var payload: AdminAuthCredentialFormInput?
        do {
            payload = try await request.decode(
                as: AdminAuthCredentialFormInput.self,
                context: context
            )
            try await payload!.validate(requiredPassword: true)
            try await interactor.execute(
                userId: identityId,
                payload: .init(
                    email: payload!.normalizedEmail,
                    password: payload!.normalizedPassword,
                    isPersistent: false
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/credentials/\(identityId)/",
                        title: "Added",
                        message: "User credential added successfully."
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
                    identityId: identityId,
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
                    identityId: identityId,
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
                    identityId: identityId,
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
