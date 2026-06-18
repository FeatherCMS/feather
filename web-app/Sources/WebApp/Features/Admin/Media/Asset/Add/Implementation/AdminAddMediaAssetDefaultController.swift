import Foundation
import Hummingbird

struct AdminAddMediaAssetDefaultController: AdminAddMediaAssetController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddMediaAssetInteractor,
            presenter: any AdminAddMediaAssetPresenter
        )

    func getAddMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let parentId =
            request.queryString("parent_id")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .nilIfEmpty ?? ""
        let view = request.queryString("view") ?? "grid"
        let picker = pickerState(request: request)
        var model = try await interactor.getAddMediaAsset()
        model = .init(
            parentId: parentId,
            fileName: "",
            type: model.type,
            title: model.title,
            altText: model.altText,
            data: model.data,
            error: model.error,
            view: view,
            action: actionPath(
                parentId: parentId.nilIfEmpty,
                view: view,
                picker: picker
            ),
            isPicker: picker.isEnabled,
            selectedAsset: nil
        )
        return presenter.renderPage(
            model: model,
            permissions: context.currentUserPermissions
        )
    }

    func postAddMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: AssetAddForm.self,
            context: context
        )
        let picker = pickerState(request: request)
        let model = try await interactor.postAddMediaAsset(payload: payload)
        if model.error == nil {
            if picker.isEnabled, model.selectedAsset != nil {
                let pickerModel = AdminAddMediaAssetModel(
                    parentId: payload.parentId,
                    fileName: "",
                    type: payload.type,
                    title: "",
                    altText: "",
                    data: "",
                    error: nil,
                    view: model.view,
                    action: actionPath(
                        parentId: payload.parentId.nilIfEmpty,
                        view: model.view,
                        picker: picker
                    ),
                    isPicker: true,
                    selectedAsset: model.selectedAsset
                )
                return
                    try presenter.renderPage(
                        model: pickerModel,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }

            var queryItems: [URLQueryItem] = []
            if let parentId = payload.parentId.nilIfEmpty {
                queryItems.append(.init(name: "parent_id", value: parentId))
            }
            if model.view != "grid" {
                queryItems.append(.init(name: "view", value: model.view))
            }
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/assets/",
                        title: "Added",
                        message: "Item added successfully.",
                        extraQueryItems: queryItems
                    )
                ]
            )
        }

        let errorModel = AdminAddMediaAssetModel(
            parentId: model.parentId,
            fileName: model.fileName,
            type: model.type,
            title: model.title,
            altText: model.altText,
            data: model.data,
            error: model.error,
            view: model.view,
            action: actionPath(
                parentId: model.parentId.nilIfEmpty,
                view: model.view,
                picker: picker
            ),
            isPicker: picker.isEnabled,
            selectedAsset: nil
        )
        return
            try presenter.renderPage(
                model: errorModel,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}

extension AdminAddMediaAssetDefaultController {
    fileprivate struct PickerState {
        let isEnabled: Bool
        let field: String?
        let allowedExtensions: [String]
        let defaultFolderPath: String?
    }

    fileprivate func pickerState(
        request: Request
    ) -> PickerState {
        .init(
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
    }

    fileprivate func actionPath(
        parentId: String?,
        view: String,
        picker: PickerState
    ) -> String {
        var queryItems: [String] = []
        if let parentId, !parentId.isEmpty {
            queryItems.append("parent_id=\(parentId.queryEncoded())")
        }
        if view != "grid" {
            queryItems.append("view=\(view.queryEncoded())")
        }
        if picker.isEnabled {
            queryItems.append("picker=1")
        }
        if let field = picker.field {
            queryItems.append("field=\(field.queryEncoded())")
        }
        if !picker.allowedExtensions.isEmpty {
            queryItems.append(
                "extensions=\(picker.allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath = picker.defaultFolderPath {
            queryItems.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        return queryItems.isEmpty
            ? "/admin/media/assets/add/"
            : "/admin/media/assets/add/?\(queryItems.joined(separator: "&"))"
    }
}
