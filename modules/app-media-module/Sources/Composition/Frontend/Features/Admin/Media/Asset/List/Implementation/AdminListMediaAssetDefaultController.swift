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
    private static let viewCookieName = "admin_media_assets_view"

    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListMediaAssetInteractor,
            any AdminListMediaAssetPresenter
        >

    func getListMediaAssets(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let parentId = request.queryString("parent_id")?
            .whitespaceTrimmed
            .emptyToNil
        let requestedView = request.queryString("view")
            .flatMap(AdminListMediaAssetModel.ViewMode.init(rawValue:))
        let storedView = request.cookies[Self.viewCookieName]
            .flatMap {
                AdminListMediaAssetModel.ViewMode(rawValue: $0.value)
            }
        let view = requestedView ?? storedView ?? .grid
        let isPicker = request.queryString("picker") == "1"
        let picker = AdminListMediaAssetModel.PickerState(
            isEnabled: isPicker,
            configuration: isPicker
                ? .init(
                    field: request.queryString("field")?.emptyToNil ?? "",
                    selectionMode: request.queryString("selection")
                        == "multiple"
                        ? .multiple
                        : .single,
                    allowedExtensions: .custom(
                        request.queryString("extensions")?
                            .split(separator: ",")
                            .map(String.init) ?? []
                    ),
                    defaultFolderPath: request.queryString(
                        "default_folder_path"
                    )?
                    .emptyToNil,
                    previewVariant: request.queryString("preview_variant")?
                        .emptyToNil
                )
                : nil,
            resetSelection: request.queryString("selection_reset") == "1"
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
            let page = try await presenter.renderListPage(
                model: model,
                search: search,
                permissions: permissions
            )
            guard let requestedView else {
                return page
            }
            return HTMLResponse(
                content: page.content,
                status: page.status,
                cookies: [
                    Cookie(
                        name: Self.viewCookieName,
                        value: requestedView.rawValue,
                        maxAge: 60 * 60 * 24 * 365,
                        path: "/admin/media/assets",
                        httpOnly: false,
                        sameSite: .lax
                    )
                ]
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
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
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
        let items = try await interactor.resolveRemoveItems(ids: selectedIds)
        return
            try await presenter.renderRemovePage(
                pageState: .init(page: page, pageSize: 20, total: 0),
                search: search,
                items: items,
                returnTo: request.queryString("returnTo")
            )
            .response(from: request, context: context)
    }

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
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
