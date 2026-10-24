import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Asset.Router.Routes

        func renderListPage(
            model: Asset.File.List.Model,
            search: String?,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            let isDialog =
                request.queryString("presentation") == "dialog"
                && request.headers[.accept]?.contains("type=admin-dialog")
                    == true
            if model.picker.isEnabled && isDialog {
                let navigation = MediaAssetPickerDialogNavigation(
                    field: model.picker.field,
                    selectionMode: model.picker.selectionMode
                )
                return try await renderEngine.renderAdminDialog(
                    request: request,
                    context: context,
                    title: model.picker.selectionMode == .multiple
                        ? "Select media assets"
                        : "Select media asset",
                    content: MediaAssetPickerDialogView(
                        navigation: navigation,
                        content: MediaAssetPickerView(
                            state: .init(
                                entries: model.entries,
                                pageState: model.pageState,
                                search: search ?? "",
                                parentId: model.parentId,
                                currentFolder: model.currentFolder,
                                ancestors: model.ancestors,
                                view: model.view,
                                picker: model.picker,
                                routes: routes
                            )
                        )
                    ),
                    size: .large
                )
            }
            if model.picker.isEnabled {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: model.picker.selectionMode == .multiple
                        ? "Select media assets"
                        : "Select media asset",
                    content: MediaAssetPickerView(
                        state: .init(
                            entries: model.entries,
                            pageState: model.pageState,
                            search: search ?? "",
                            parentId: model.parentId,
                            currentFolder: model.currentFolder,
                            ancestors: model.ancestors,
                            view: model.view,
                            picker: model.picker,
                            routes: routes
                        )
                    )
                )
            }
            let content = AssetListView(
                state: .init(
                    entries: model.entries,
                    pageState: model.pageState,
                    search: search ?? "",
                    parentId: model.parentId,
                    currentFolder: model.currentFolder,
                    ancestors: model.ancestors,
                    view: model.view,
                    picker: model.picker,
                    permissions: permissions,
                    routes: routes
                )
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media assets",
                content: content
            )
        }

        func renderErrorPage(
            message: String,
            picker: Bool
        ) async throws -> HTMLResponse {
            let isDialog =
                request.queryString("presentation") == "dialog"
                && request.headers[.accept]?.contains("type=admin-dialog")
                    == true
            if picker {
                let errorContent = MediaAssetErrorView(
                    info: "Unable to load media assets.",
                    message: message
                )
                if isDialog {
                    return try await renderEngine.renderAdminDialog(
                        request: request,
                        context: context,
                        title: "Select media asset",
                        content: MediaAssetPickerDialogView(
                            navigation: pickerNavigation(),
                            content: errorContent
                        ),
                        size: .large
                    )
                }
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Select media asset",
                    content: errorContent
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media assets",
                content: MediaAssetErrorView(
                    info: "Unable to load media assets.",
                    message: message
                )
            )
        }

        private func pickerNavigation() -> MediaAssetPickerDialogNavigation {
            MediaAssetPickerDialogNavigation(
                field: request.queryString("field")?.emptyToNil,
                selectionMode: request.queryString("selection") == "multiple"
                    ? .multiple
                    : .single
            )
        }
        func renderInvalidNoncePage(
            cancel: String
        ) async throws -> HTMLResponse {
            let page = try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove media assets",
                content: AdminStatusView(
                    state: .init(
                        title: "Confirmation expired",
                        message:
                            "This confirmation is no longer valid. Please try again."
                    ),
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
                )
            )
            return HTMLResponse(content: page.content, status: .badRequest)
        }
    }
}
