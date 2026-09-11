import FeatherAdmin
import HTML
import Hummingbird
import SystemContracts

struct AdminRemoveSystemVariableDefaultController:
    AdminRemoveSystemVariableController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveSystemVariableInteractor,
            presenter: any AdminRemoveSystemVariablePresenter
        )

    func getRemoveSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete) else {
            throw HTTPError(.forbidden)
        }
        let (_, presenter) = buildRuntime(request, context)
        let ids = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListRemoveRedirect.location(
                        path: SystemVariableRoutes.list.description,
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return try presenter.renderRemoveConfirmation(
            page: page,
            search: search,
            ids: ids,
            permissions: context.currentUserPermissions
        ).response(from: request, context: context)
    }

    func postRemoveSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete) else {
            throw HTTPError(.forbidden)
        }
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedIds.isEmpty {
            try await interactor.delete(ids: payload.normalizedIds)
        }
        let location = ListRemoveRedirect.location(
            path: SystemVariableRoutes.list.description,
            page: payload.normalizedPage,
            search: payload.normalizedSearch,
            title: nil,
            message: nil
        )
        guard !payload.normalizedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "System variable removed successfully."
            )
        )
    }
}
