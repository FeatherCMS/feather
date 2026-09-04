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
        let (interactor, presenter) = buildRuntime(request, context)
        let emails = try await interactor.listEmails()
        return presenter.renderPage(
            form: presenter.formState(
                userId: "",
                emails: emails,
                email: "",
                password: ""
            ),
            permissions: context.currentUserPermissions
        )
    }

    func postAddCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        var payload: AdminAuthCredentialFormInput?
        do {
            payload = try await request.decode(
                as: AdminAuthCredentialFormInput.self,
                context: context
            )
            try await payload!
                .validate(
                    requiredPassword: true,
                    validateUserId: false
                )
            try await interactor.execute(
                payload: .init(
                    userId: payload!.normalizedUserId,
                    email: payload!.normalizedEmail,
                    password: payload!.normalizedPassword
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/credentials/",
                        title: "Added",
                        message: "User credential added successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
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
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch let error as OpenAPIRepositoryError {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = presenter.format(error: error)
            return
                try presenter.renderPage(
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch {
            var state = presenter.formState(
                userId: payload?.normalizedUserId ?? "",
                emails: (try? await interactor.listEmails()) ?? [],
                email: payload?.normalizedEmail ?? "",
                password: ""
            )
            state.error = error.displayMessage
            return
                try presenter.renderPage(
                    form: state,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
