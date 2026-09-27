import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import HTTPTypes
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetDefaultPresenter: AdminAddMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaAssetModel
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        let content = AssetAddView(
            state: .init(
                form: .init(
                    parentId: model.parentId,
                    fileName: model.fileName,
                    extension: model.extension,
                    title: model.title,
                    altText: model.altText,
                    data: model.data,
                    error: model.error,
                    view: model.view,
                    action: model.action,
                    isPicker: model.isPicker,
                    isDialog: isDialog,
                    selectedAsset: model.selectedAsset
                )
            )
        )
        if isDialog {
            if model.isPicker {
                let navigation = MediaAssetPickerDialogNavigation(
                    parentId: model.parentId.emptyToNil,
                    view: model.view,
                    field: request.queryString("field")?.emptyToNil,
                    allowedExtensions: pickerExtensions(),
                    defaultFolderPath: request.queryString("default_folder_path")?.emptyToNil
                )
                return try await renderEngine.renderNewAdminDialog(
                    request: request,
                    context: context,
                    title: "Select media asset",
                    content: MediaAssetPickerDialogView(
                        navigation: navigation,
                        activeTab: .upload,
                        content: content
                    ),
                    size: .large
                )
            }
            return try await renderEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: "Add media asset",
                content: content,
                size: .small
            )
        }
        if model.isPicker {
            return renderEngine.renderPublicPage(
                request: request,
                title: "Upload media asset",
                description: "Upload media asset",
                imagePath: "images/logos/logo.png",
                content: Div {
                    buildContext.build(content)
                }
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add media asset",
            content: content
        )
    }

    private func pickerExtensions() -> [String] {
        request.queryString("extensions")?
            .split(separator: ",")
            .map { $0.whitespaceTrimmed.lowercased() }
            .filter { !$0.isEmpty } ?? []
    }

}
