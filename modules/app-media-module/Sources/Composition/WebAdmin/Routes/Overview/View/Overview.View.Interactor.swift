import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Overview.View {
    enum Interactor {}
}

extension Overview.View.Interactor {
    protocol Interface: Sendable {

        func getOverview() async throws -> Overview.View.Model
    }
}
