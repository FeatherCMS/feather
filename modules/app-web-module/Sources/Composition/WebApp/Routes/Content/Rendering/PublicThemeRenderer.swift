public import FeatherWebApp

public protocol PublicThemeRenderer: Sendable {
    func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> HTMLResponse
}
