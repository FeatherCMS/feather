import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Remove {
    struct Infrastructure: Sendable {
        let repository: Asset.File.Remove.Repository.OpenAPI

        init(api: MediaAdminAPIClient) {
            self.repository = .init(api: api)
        }
    }
}
