import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewMediaAssetPresenter: Sendable {

    func renderDetailsPage(
        model: AdminViewMediaAssetModel?,
        id: String,
        permissions: NewAdminListActions,
        error: String?
    ) async throws -> HTMLResponse
}
