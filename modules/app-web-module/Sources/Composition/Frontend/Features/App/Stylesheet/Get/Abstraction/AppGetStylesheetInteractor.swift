import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AppGetStylesheetInteractor: Sendable {

    func getStyleCSS() async throws -> CSSResponse
}
