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

extension Asset.File.View {
    enum Interactor {}
}

extension Asset.File.View.Interactor {
    protocol Interface: Sendable {

        func getMediaAsset(
            id: String
        ) async throws -> Asset.File.View.Model
    }
}
