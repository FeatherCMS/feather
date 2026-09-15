import AccountContracts
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
import WebBuilders
import WebComponents

struct AdminEditAccountProfileDefaultController:
    AdminEditAccountProfileController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditAccountProfileInteractor,
            presenter: any AdminEditAccountProfilePresenter
        )

    func getEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return try await presenter.renderDeniedPage(permissions: [])
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AccountPermissions.Profile.update
            )
        else {
            return try await presenter.renderDeniedPage(
                permissions: permissions
            )
        }

        let profile = try await interactor.loadProfile(account: account)
        return try await presenter.renderPage(
            state: .init(
                id: profile.id,
                isEdited: request.hasQueryFlag("edited"),
                form: formState(
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    profileImageAssetId: profile.profileImageAssetId,
                    selectedImageAsset: profile.profileImageAsset
                ),
                breadcrumb: breadcrumb()
            ),
            permissions: permissions
        )
    }

    func postEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard let account = context.account else {
            return try await presenter.renderDeniedPage(permissions: [])
                .response(from: request, context: context)
        }

        let permissions = account.permissionSet
        guard
            context.isCurrentUserAllowed(
                to: AccountPermissions.Profile.update
            )
        else {
            return
                try await presenter.renderDeniedPage(permissions: permissions)
                .response(from: request, context: context)
        }

        let profile = try await interactor.loadProfile(account: account)
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminEditAccountProfileFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            var state = formState(
                firstName: profile.firstName,
                lastName: profile.lastName,
                profileImageAssetId: profile.profileImageAssetId,
                selectedImageAsset: profile.profileImageAsset
            )
            state.error = "This form has expired. Please reload the page."
            return try await renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: .init(
                    id: profile.id,
                    isEdited: false,
                    form: state,
                    breadcrumb: breadcrumb()
                )
            )
        }
        let payload = nonceRequest.input
        do {
            try await interactor.execute(
                entity: .init(
                    id: profile.id,
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    profileImageAssetId: payload.profileImageAssetId,
                    profileImageAsset: nil
                )
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/account/profile/edit/",
                notification: .init(
                    title: "Saved",
                    message: "Profile edited successfully."
                )
            )
        }
        catch let error as ValidationError {
            return try await renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: validationState(
                    id: profile.id,
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    profileImageAssetId: payload.profileImageAssetId,
                    failures: error.failures
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: errorState(
                    id: profile.id,
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    profileImageAssetId: payload.profileImageAssetId,
                    error: error
                )
            )
        }
        catch {
            return try await renderEditResponse(
                request: request,
                context: context,
                presenter: presenter,
                permissions: permissions,
                state: genericErrorState(
                    id: profile.id,
                    firstName: payload.firstName,
                    lastName: payload.lastName,
                    profileImageAssetId: payload.profileImageAssetId,
                    message: error.displayMessage
                )
            )
        }
    }

    private func formState(
        firstName: String?,
        lastName: String?,
        profileImageAssetId: String?,
        selectedImageAsset: NewAdminMediaAsset? = nil
    ) -> AccountProfileForm.State {
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
            profileImageAssetId: .init(
                key: "profileImageAssetId",
                label: "Profile image",
                value: profileImageAssetId,
                error: nil
            ),
            selectedImageAsset: selectedImageAsset,
            error: nil,
            success: nil
        )
    }

    private func validationState(
        id: String,
        firstName: String?,
        lastName: String?,
        profileImageAssetId: String?,
        failures: [FeatherValidation.Failure]
    ) -> AccountProfileEdit.State {
        var state = AccountProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                profileImageAssetId: profileImageAssetId
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
        profileImageAssetId: String?,
        error: OpenAPIRepositoryError
    ) -> AccountProfileEdit.State {
        var state = AccountProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                profileImageAssetId: profileImageAssetId
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
        profileImageAssetId: String?,
        message: String
    ) -> AccountProfileEdit.State {
        var state = AccountProfileEdit.State(
            id: id,
            isEdited: false,
            form: formState(
                firstName: firstName,
                lastName: lastName,
                profileImageAssetId: profileImageAssetId
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
        presenter: any AdminEditAccountProfilePresenter,
        permissions: Set<String>,
        state: AccountProfileEdit.State
    ) async throws -> Response {
        try await presenter.renderPage(
            state: state,
            permissions: permissions
        )
        .response(from: request, context: context)
    }

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Account", link: "/admin/account/"),
            .init(label: "Profile", link: "/admin/account/profile/"),
        ]
    }
}
