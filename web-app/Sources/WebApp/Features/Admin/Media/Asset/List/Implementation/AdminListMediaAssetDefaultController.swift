import Foundation
import Hummingbird

struct AdminListMediaAssetDefaultController: AdminListMediaAssetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListMediaAssetInteractor,
            presenter: any AdminListMediaAssetPresenter
        )

    func getListMediaAssets(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
        let view =
            AdminListMediaAssetModel.ViewMode(
                rawValue: request.queryString("view") ?? ""
            ) ?? .grid
        let picker = AdminListMediaAssetModel.PickerState(
            isEnabled: request.queryString("picker") == "1",
            field: request.queryString("field")?.nilIfEmpty,
            allowedExtensions: request.queryString("extensions")?
                .split(separator: ",")
                .map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        .lowercased()
                }
                .filter { !$0.isEmpty } ?? [],
            defaultFolderPath: request.queryString("default_folder_path")?
                .nilIfEmpty
        )
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminMedia.Scope.assets
        )
        let emptyModel = AdminListMediaAssetModel(
            folders: [],
            items: [],
            total: 0,
            page: page,
            pageSize: 20,
            parentId: parentId,
            currentFolder: nil,
            ancestors: [],
            view: view,
            picker: picker
        )
        let model: AdminListMediaAssetModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listMediaAssets(
                    page: page,
                    search: search,
                    parentId: parentId,
                    view: view,
                    picker: picker
                )
                error = nil
            }
            catch let caughtError {
                model = emptyModel
                error = caughtError.displayMessage
            }
        }
        else {
            model = emptyModel
            error = nil
        }
        return presenter.renderListPage(
            model: model,
            page: page,
            search: search,
            parentId: parentId,
            view: view,
            isAdded: request.hasQueryFlag("added"),
            isRemoved: request.hasQueryFlag("removed"),
            permissions: permissions,
            error: error
        )
    }

    func bulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
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
                        view: view,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return
            try presenter.renderBulkRemoveConfirmation(
                page: page,
                search: search,
                parentId: parentId,
                view: view,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func bulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        let parentId = request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty
        let view =
            AdminListMediaAssetModel.ViewMode(
                rawValue: request.queryString("view") ?? ""
            ) ?? .grid
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: redirectLocation(
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    parentId: parentId,
                    view: view,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Media asset removed successfully." : nil
                )
            ]
        )
    }

    func deleteFolder(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        guard let id = context.parameters.get("id", as: String.self) else {
            return Response(status: .badRequest)
        }
        let payload = try await request.decode(
            as: MediaFolderDeleteForm.self,
            context: context
        )
        _ = try await interactor.deleteFolder(id: id)
        return Response(
            status: .seeOther,
            headers: [
                .location: redirectLocation(
                    page: payload.page,
                    search: payload.search.nilIfEmpty,
                    parentId: payload.parentId.nilIfEmpty,
                    view: .init(rawValue: payload.view) ?? .grid,
                    title: "Removed",
                    message: "Media folder removed successfully."
                )
            ]
        )
    }
}

extension AdminListMediaAssetDefaultController {
    fileprivate func redirectLocation(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        title: String? = nil,
        message: String? = nil
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
        if let title, let message {
            return AdminToastRedirect.location(
                defaultPath: "/admin/media/assets/",
                title: title,
                message: message,
                extraQueryItems: queryItems
            )
        }
        var components = URLComponents()
        components.path = "/admin/media/assets/"
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? "/admin/media/assets/"
    }
}
