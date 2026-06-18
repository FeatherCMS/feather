import FeatherValidation
import HTML
import Hummingbird

struct AdminEditAuthProfileDefaultController:
    AdminEditAuthProfileController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditAuthProfileInteractor,
            presenter: any AdminEditAuthProfilePresenter
        )

    func getEditAuthProfile(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return presenter.renderDeniedPage(permissions: [])
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: .update,
                scope: AdminAuth.Scope.profile
            )
        else {
            return presenter.renderDeniedPage(permissions: permissions)
        }

        let profile = try await interactor.loadProfile(account: account)
        return presenter.renderPage(
            state: .init(
                id: profile.id,
                isEdited: request.hasQueryFlag("edited"),
                form: formState(
                    email: profile.email,
                    password: ""
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    func postEditAuthProfile(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return try presenter.renderDeniedPage(permissions: [])
                .response(from: request, context: context)
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: .update,
                scope: AdminAuth.Scope.profile
            )
        else {
            return try presenter.renderDeniedPage(permissions: permissions)
                .response(from: request, context: context)
        }

        let profile = try await interactor.loadProfile(account: account)
        do {
            let payload = try await request.decode(
                as: AdminEditAuthProfileFormInput.self,
                context: context
            )
            try await payload.validate()
            try await interactor.execute(
                entity: .init(
                    id: profile.id,
                    email: payload.normalizedEmail,
                    password: payload.normalizedPassword
                )
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/auth/profile/edit/",
                        title: "Saved",
                        message: "Profile edited successfully."
                    )
                ]
            )
        }
        catch let error as ValidationError {
            return try renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: validationState(
                    id: profile.id,
                    email: profile.email,
                    password: "",
                    failures: error.failures
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: errorState(
                    id: profile.id,
                    email: profile.email,
                    password: "",
                    error: error
                )
            )
        }
        catch {
            return try renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: genericErrorState(
                    id: profile.id,
                    email: profile.email,
                    password: "",
                    message: error.displayMessage
                )
            )
        }
    }

    private func formState(
        email: String,
        password: String
    ) -> AuthProfileForm.State {
        .init(
            email: .init(
                key: "email",
                label: "Email address",
                value: email,
                error: nil
            ),
            password: .init(
                key: "password",
                label: "Password",
                value: password,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    private func validationState(
        id: String,
        email: String,
        password: String,
        failures: [FeatherValidation.Failure]
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(email: email, password: password),
            breadcrumb: breadcrumb()
        )
        var errors: [String: String] = [:]
        for failure in failures {
            errors[failure.key] = failure.message
        }
        state.form.apply(errors: errors)
        return state
    }

    private func errorState(
        id: String,
        email: String,
        password: String,
        error: OpenAPIRepositoryError
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(email: email, password: password),
            breadcrumb: breadcrumb()
        )
        state.form.error = format(error: error)
        return state
    }

    private func genericErrorState(
        id: String,
        email: String,
        password: String,
        message: String
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(email: email, password: password),
            breadcrumb: breadcrumb()
        )
        state.form.error = message
        return state
    }

    private func format(
        error: OpenAPIRepositoryError
    ) -> String {
        error.errorDescription
    }

    private func renderEditResponse(
        request: Request,
        context: AppRequestContext,
        presenter: any AdminEditAuthProfilePresenter,
        permissions: Set<String>,
        state: AuthProfileEdit.State
    ) throws -> Response {
        try presenter.renderPage(
            state: state,
            permissions: permissions
        )
        .response(from: request, context: context)
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Auth", link: "/admin/auth/"),
                .init(label: "Profile", link: "/admin/auth/profile/"),
                .init(
                    label: "Edit",
                    link: "/admin/auth/profile/edit/"
                ),
            ]
        )
    }
}
