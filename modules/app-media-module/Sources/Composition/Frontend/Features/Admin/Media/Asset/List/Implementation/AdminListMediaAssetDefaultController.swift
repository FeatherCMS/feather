import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetDefaultController: AdminListMediaAssetController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListMediaAssetInteractor,
            presenter: any AdminListMediaAssetPresenter
        )

    func getListMediaAssets(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let parentId = request.queryString("parent_id")?
            .whitespaceTrimmed
            .emptyToNil
        let view =
            AdminListMediaAssetModel.ViewMode(
                rawValue: request.queryString("view") ?? ""
            ) ?? .grid
        let picker = AdminListMediaAssetModel.PickerState(
            isEnabled: request.queryString("picker") == "1",
            field: request.queryString("field")?.emptyToNil,
            allowedExtensions: request.queryString("extensions")?
                .split(separator: ",")
                .map {
                    $0.whitespaceTrimmed
                        .lowercased()
                }
                .filter { !$0.isEmpty } ?? [],
            defaultFolderPath: request.queryString("default_folder_path")?
                .emptyToNil
        )
        let permissions = context.currentUserAdminListActions
        guard permissions.allows(MediaPermissions.Assets.list) else {
            return try await presenter.renderErrorPage(
                message: "Your account cannot access media assets.",
                picker: picker.isEnabled
            )
        }
        do {
            let model = try await interactor.listMediaAssets(
                page: page,
                search: search,
                parentId: parentId,
                view: view,
                picker: picker
            )
            return try await presenter.renderListPage(
                model: model,
                search: search,
                permissions: permissions
            )
        }
        catch let caughtError {
            return try await presenter.renderErrorPage(
                message: caughtError.displayMessage,
                picker: picker.isEnabled
            )
        }
    }

    func removeConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: MediaPermissions.Assets.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    message: "Your account cannot remove media assets.",
                    picker: false
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
                    .location: redirectLocation(
                        request: request
                    )
                ]
            )
        }
        return
            try await presenter.renderRemovePage(
                pageState: .init(page: page, pageSize: 20, total: 0),
                search: search,
                items: selectedIds.map { .init(id: $0, label: $0) },
                returnTo: request.queryString("returnTo")
            )
            .response(from: request, context: context)
    }

    func remove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        guard
            context.isCurrentUserAllowed(to: MediaPermissions.Assets.delete)
        else {
            return
                try await presenter.renderErrorPage(
                    message: "Your account cannot remove media assets.",
                    picker: false
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
                            path: MediaAssetRoutes.list.description,
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
                path: MediaAssetRoutes.list.description,
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
                        ? "Media item removed successfully."
                        : "Media items removed successfully."
                )
            )
        }
        catch {
            return
                try await presenter.renderErrorPage(
                    message: error.displayMessage,
                    picker: false
                )
                .response(from: request, context: context)
        }
    }

}

extension AdminListMediaAssetDefaultController {
    fileprivate func redirectLocation(
        request: Request
    ) -> String {
        NewAdminLocation.removeCancel(
            path: MediaAssetRoutes.list.description,
            returnTo: request.queryString("returnTo")
        )
    }
}
