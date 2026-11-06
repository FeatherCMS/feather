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

extension Overview.View.Interactor {
    struct Default: Interface {
        func getOverview() async throws -> Overview.View.Model {
            .init(title: "Media management")
        }
    }
}
