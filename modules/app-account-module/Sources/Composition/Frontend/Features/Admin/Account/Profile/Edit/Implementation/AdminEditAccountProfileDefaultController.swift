import AccountContracts
import FeatherAdmin
import Hummingbird

struct AdminEditAccountProfileDefaultController:
    AdminEditAccountProfileController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            repository: any AdminEditAccountProfileRepository,
            presenter: any AdminEditAccountProfilePresenter
        )

    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let userID = try context.requiredParameter("userId")
        let canEdit = context.isCurrentUserAllowed(
            to: AccountPermissions.Profile.manage
        )
        guard canEdit else {
            return runtime.presenter.renderDeniedPage(
                userID: userID,
                permissions: context.currentUserPermissions
            )
        }
        let model = try await runtime.repository.load(userID: userID)
        return runtime.presenter.render(
            userID: userID,
            model: model,
            canEdit: canEdit,
            isEdited: request.hasQueryFlag("edited"),
            permissions: context.currentUserPermissions
        )
    }

    func post(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let userID = try context.requiredParameter("userId")
        guard context.isCurrentUserAllowed(to: AccountPermissions.Profile.manage)
        else {
            return Response(status: .forbidden)
        }
        let input = try await request.decode(
            as: AdminEditAccountProfileFormInput.self,
            context: context
        )
        try await runtime.repository.save(userID: userID, input: input)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/account/users/\(userID)/profile/",
                    title: "Saved",
                    message: "Profile edited successfully."
                )
            ]
        )
    }
}
