import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaProcessorDefaultController:
    AdminListMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListMediaProcessorInteractor,
            presenter: any AdminListMediaProcessorPresenter
        )

    func getListMediaProcessors(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(MediaPermissions.Processors.list) else {
            return try await presenter.renderErrorPage(
                message: "Your account cannot access media processors."
            )
        }
        do {
            let model = try await interactor.listMediaProcessors(
                page: page,
                search: search
            )
            return try await presenter.renderListPage(
                model: model,
                permissions: permissions,
                search: search
            )
        }
        catch let caughtError {
            return try await presenter.renderErrorPage(
                message: caughtError.displayMessage
            )
        }
    }

    func removeConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: MediaPermissions.Processors.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    message: "Your account cannot remove media processors."
                )
                .response(from: request, context: context)
        }
        let selectedIds = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.removeCancel(
                        path: MediaProcessorRoutes.list.description,
                        returnTo: request.queryString("returnTo")
                    )
                ]
            )
        }
        do {
            return
                try await presenter.renderRemoveConfirmation(
                    pageState: .init(page: page, pageSize: 20, total: 0),
                    search: search,
                    selectedIds: selectedIds,
                    returnTo: request.queryString("returnTo")
                )
                .response(from: request, context: context)
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    message: error.displayMessage
                )
                .response(from: request, context: context)
        }
    }

    func remove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: MediaPermissions.Processors.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    message: "Your account cannot remove media processors."
                )
                .response(from: request, context: context)
        }
        var returnTo = request.queryString("returnTo")
        do {
            let payload = try await request.decode(
                as: NonceRequest<NewAdminListRemoveFormInput>.self,
                context: context
            )
            returnTo = payload.input.normalizedReturnTo
            guard
                await AdminNonceStore.shared.consume(
                    payload.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return
                    try await presenter.renderInvalidNoncePage(
                        cancel: NewAdminLocation.removeCancel(
                            path: MediaProcessorRoutes.list.description,
                            returnTo: returnTo
                        )
                    )
                    .response(from: request, context: context)
            }

            let ids = payload.input.normalizedIds
            if !ids.isEmpty {
                try await interactor.remove(ids: ids)
            }
            let location = NewAdminLocation.removeCancel(
                path: MediaProcessorRoutes.list.description,
                returnTo: returnTo
            )
            guard !ids.isEmpty else {
                return Response(
                    status: .seeOther,
                    headers: [.location: location]
                )
            }
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: ids.count == 1
                        ? "Media processor removed successfully."
                        : "Media processors removed successfully."
                )
            )
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    message: error.displayMessage
                )
                .response(from: request, context: context)
        }
    }
}
