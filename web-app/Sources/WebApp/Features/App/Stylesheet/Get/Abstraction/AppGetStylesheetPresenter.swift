import Hummingbird

protocol AppGetStylesheetPresenter: Sendable {

    func render(
        css: CSSResponse
    ) -> CSSResponse
}
