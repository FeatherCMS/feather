import AccountModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Edit.Controller {

    struct Default:
        Profile.Edit.Controller.Interface
    {
        let routes: Profile.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Profile.Edit.Interactor.Interface,
                any Profile.Edit.Presenter.Interface
            >

        func getEditProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            let account = context.account

            let permissions = account.permissionSet
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
                    breadcrumb: routes.profileBreadcrumb
                ),
                permissions: permissions
            )
        }

        func postEditProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let __runtimeBuild2 = buildRuntime(request, context)
            let interactor = __runtimeBuild2.interactor
            let presenter = __runtimeBuild2.presenter
            let account = context.account

            let permissions = account.permissionSet
            let profile = try await interactor.loadProfile(account: account)
            let nonceRequest = try await request.decode(
                as: NonceRequest<Profile.Edit.Form.Input>.self,
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
                        breadcrumb: routes.profileBreadcrumb
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
                    to: routes.profileEdit.path + "/",
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
            selectedImageAsset: AdminMediaAsset? = nil
        ) -> ProfileForm.State {
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
        ) -> ProfileEdit.State {
            var state = ProfileEdit.State(
                id: id,
                isEdited: false,
                form: formState(
                    firstName: firstName,
                    lastName: lastName,
                    profileImageAssetId: profileImageAssetId
                ),
                breadcrumb: routes.profileBreadcrumb
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
        ) -> ProfileEdit.State {
            var state = ProfileEdit.State(
                id: id,
                isEdited: false,
                form: formState(
                    firstName: firstName,
                    lastName: lastName,
                    profileImageAssetId: profileImageAssetId
                ),
                breadcrumb: routes.profileBreadcrumb
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
        ) -> ProfileEdit.State {
            var state = ProfileEdit.State(
                id: id,
                isEdited: false,
                form: formState(
                    firstName: firstName,
                    lastName: lastName,
                    profileImageAssetId: profileImageAssetId
                ),
                breadcrumb: routes.profileBreadcrumb
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
            context: AuthenticatedRequestContext,
            presenter: any Profile.Edit.Presenter.Interface,
            permissions: Set<String>,
            state: ProfileEdit.State
        ) async throws -> Response {
            try await presenter.renderPage(
                state: state,
                permissions: permissions
            )
            .response(from: request, context: context)
        }

    }
}
