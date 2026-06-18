import Hummingbird

protocol AppGetStylesheetInteractor: Sendable {

    func getStyleCSS() async throws -> CSSResponse
}
