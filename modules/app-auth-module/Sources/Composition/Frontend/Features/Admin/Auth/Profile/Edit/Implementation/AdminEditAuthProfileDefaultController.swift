import AuthAdminAPI
import AuthAppAPI
import AuthContracts
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

struct AdminEditAuthProfileDefaultController:
    AdminEditAuthProfileController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAuthProfileInteractor,
            presenter: any AdminEditAuthProfilePresenter
        )

    func getEditAuthProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return presenter.renderDeniedPage(permissions: [])
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AuthPermissions.Profile.update
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
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    imageURL: profile.imageURL
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    func postEditAuthProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return try presenter.renderDeniedPage(permissions: [])
                .response(from: request, context: context)
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AuthPermissions.Profile.update
            )
        else {
            return try presenter.renderDeniedPage(permissions: permissions)
                .response(from: request, context: context)
        }

        let profile = try await interactor.loadProfile(account: account)
        let payload = try await request.decode(
            as: AdminEditAuthProfileFormInput.self,
            context: context
        )
        do {
            try await interactor.execute(
                entity: .init(
                    id: profile.id,
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    imageURL: payload.imageURL
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
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    imageURL: payload.imageURL,
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
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    imageURL: payload.imageURL,
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
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    imageURL: payload.imageURL,
                    message: error.displayMessage
                )
            )
        }
    }

    private func formState(
        firstName: String?,
        lastName: String?,
        imageURL: String?
    ) -> AuthProfileForm.State {
        .init(
            firstName: .init(
                key: "firstName",
                label: "First name",
                value: firstName,
                error: nil
            ),
            lastName: .init(
                key: "lastName",
                label: "Last name",
                value: lastName,
                error: nil
            ),
            imageURL: .init(
                key: "imageURL",
                label: "Profile image",
                value: imageURL,
                error: nil
            ),
            error: nil,
            success: nil
        )
    }

    private func validationState(
        id: String,
        firstName: String?,
        lastName: String?,
        imageURL: String?,
        failures: [FeatherValidation.Failure]
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                imageURL: imageURL
            ),
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
        firstName: String?,
        lastName: String?,
        imageURL: String?,
        error: OpenAPIRepositoryError
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                imageURL: imageURL
            ),
            breadcrumb: breadcrumb()
        )
        state.form.error = format(error: error)
        return state
    }

    private func genericErrorState(
        id: String,
        firstName: String?,
        lastName: String?,
        imageURL: String?,
        message: String
    ) -> AuthProfileEdit.State {
        var state = AuthProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                imageURL: imageURL
            ),
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
        context: DefaultRequestContext,
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
