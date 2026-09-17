import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetDefaultPresenter: AdminAddMediaAssetPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaAssetModel
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
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
                    selectedAsset: model.selectedAsset
                )
            )
        )
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

}
