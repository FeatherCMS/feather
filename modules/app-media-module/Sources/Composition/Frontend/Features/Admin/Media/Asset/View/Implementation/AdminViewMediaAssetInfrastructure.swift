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

struct AdminViewMediaAssetInfrastructure: Sendable {
    let repository: AdminViewMediaAssetOpenAPIRepository

    init(api: MediaAdminAPIClient) {
        self.repository = .init(api: api)
    }
}
