import FeatherAdmin
import FeatherContracts
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
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete)
        else { return try await presenter.renderErrorPage(info: "Forbidden", message: "Your account cannot remove system variables.", cancel: SystemVariableRoutes.list.description).response(from: request, context: context) }
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
        return
            try await presenter.renderRemoveConfirmation(
                page: page,
                search: search,
                ids: ids,
                names: try await interactor.names(ids: ids),
                fromDetails: request.queryString("from") == "details",
                fromEdit: request.queryString("from") == "edit"
            )
            .response(from: request, context: context)
    }

    func postRemoveSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: SystemPermissions.Variables.delete)
        else { return try await presenter.renderErrorPage(info: "Forbidden", message: "Your account cannot remove system variables.", cancel: SystemVariableRoutes.list.description).response(from: request, context: context) }
        var errorPage = (
            page: request.queryPage(), search: request.querySearch()
        )
        do {
            let payload = try await request.decode(
                as: ListRemoveFormInput.self,
                context: context
            )
            errorPage = (payload.normalizedPage, payload.normalizedSearch)
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                throw HTTPError(.forbidden)
            }
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
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: payload.normalizedIds.count == 1
                        ? "System variable removed successfully."
                        : "\(payload.normalizedIds.count) system variables removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try await presenter.renderErrorPage(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    cancel: ListRemoveRedirect.location(
                        path: SystemVariableRoutes.list.description,
                        page: errorPage.page,
                        search: errorPage.search,
                        title: nil,
                        message: nil
                    )
                )
                .response(from: request, context: context)
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    info: "Unable to remove system variables.",
                    message: error.displayMessage,
                    cancel: ListRemoveRedirect.location(
                        path: SystemVariableRoutes.list.description,
                        page: errorPage.page,
                        search: errorPage.search,
                        title: nil,
                        message: nil
                    )
                )
                .response(from: request, context: context)
        }
    }
}
