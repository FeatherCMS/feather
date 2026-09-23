import FeatherAdmin

public protocol PublicThemeRenderer: Sendable {
    func render(
        templateIdentifier: String?,
        context: [String: any Sendable]
    ) -> HTMLResponse
}
