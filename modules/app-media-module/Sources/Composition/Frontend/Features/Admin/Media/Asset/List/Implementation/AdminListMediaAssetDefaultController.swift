import FeatherAdmin
import FeatherContracts
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
            .trimmingCharacters(in: .whitespacesAndNewlines)
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
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
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
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .emptyToNil
        let view =
            AdminListMediaAssetModel.ViewMode(
                rawValue: request.queryString("view") ?? ""
            ) ?? .grid
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: redirectLocation(
                        page: page,
                        search: search,
                        parentId: parentId,
                        view: view
                    )
                ]
            )
        }
        return
            try await presenter.renderRemoveConfirmation(
                pageState: .init(page: page, pageSize: 20, total: 0),
                search: search,
                parentId: parentId,
                view: view,
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
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .emptyToNil
        let view =
            AdminListMediaAssetModel.ViewMode(
                rawValue: request.queryString("view") ?? ""
            ) ?? .grid
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = redirectLocation(
            page: payload.normalizedPage,
            search: payload.normalizedSearch,
            parentId: parentId,
            view: view
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
                    ? "Media asset removed successfully."
                    : "Media assets removed successfully."
            )
        )
    }

    func deleteFolder(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        guard let id = context.parameters.get("id", as: String.self) else {
            return Response(status: .badRequest)
        }
        let payload = try await request.decode(
            as: MediaFolderDeleteForm.self,
            context: context
        )
        try await interactor.remove(ids: [id])
        let location = redirectLocation(
            page: payload.page,
            search: payload.search.emptyToNil,
            parentId: payload.parentId.emptyToNil,
            view: .init(rawValue: payload.view) ?? .grid
        )
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "Media folder removed successfully."
            )
        )
    }
}

extension AdminListMediaAssetDefaultController {
    fileprivate func redirectLocation(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode
    ) -> String {
        var queryItems: [URLQueryItem] = []
        if page > 1 {
            queryItems.append(.init(name: "page", value: String(page)))
        }
        if let search, !search.isEmpty {
            queryItems.append(.init(name: "search", value: search))
        }
        if let parentId, !parentId.isEmpty {
            queryItems.append(.init(name: "parent_id", value: parentId))
        }
        if view != .grid {
            queryItems.append(.init(name: "view", value: view.rawValue))
        }
        var components = URLComponents()
        components.path = MediaAssetRoutes.list.description
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? "/admin/media/assets/"
    }
}
