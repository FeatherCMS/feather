import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaAssetPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
