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

extension Asset.File.View {
    struct Infrastructure: Sendable {
        let repository: any Asset.File.View.Repository.Interface

        init(api: API.Client) {
            self.repository = .init(api: api)
        }
    }
}
