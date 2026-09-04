import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddMediaAssetPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
