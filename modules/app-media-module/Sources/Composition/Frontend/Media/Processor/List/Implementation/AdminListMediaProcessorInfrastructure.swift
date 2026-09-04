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

struct AdminListMediaProcessorInfrastructure: Sendable {
    let repository: AdminMediaProcessorOpenAPIRepository

    init(api: MediaAdminAPIClient) {
        self.repository = .init(api: api)
    }
}
