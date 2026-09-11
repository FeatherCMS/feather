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

protocol AdminGetMediaAssetPresenter: Sendable {

    func renderPage(
        model: AdminGetMediaAssetModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
