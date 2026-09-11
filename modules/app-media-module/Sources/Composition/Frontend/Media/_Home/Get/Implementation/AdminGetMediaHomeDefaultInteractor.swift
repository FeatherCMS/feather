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

struct AdminGetMediaHomeDefaultInteractor: AdminGetMediaHomeInteractor {
    func getHome() async throws -> AdminGetMediaHomeModel {
        .init(title: "Media management")
    }
}
