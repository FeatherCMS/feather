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
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.url(
                        path: MediaProcessorRoutes.list.description,
                        page: page,
                        search: search
                    )
                ]
            )
        }
        return
            try await presenter.renderRemoveConfirmation(
                pageState: .init(page: page, pageSize: 20, total: 0),
                search: search,
                selectedIds: selectedIds
            )
            .response(from: request, context: context)
    }

    func remove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = NewAdminLocation.url(
            path: MediaProcessorRoutes.list.description,
            page: payload.normalizedPage,
            search: payload.normalizedSearch
        )
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [.location: location]
            )
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: payload.normalizedSelectedIds.count == 1
                    ? "Media processor removed successfully."
                    : "Media processors removed successfully."
            )
        )
    }
}
