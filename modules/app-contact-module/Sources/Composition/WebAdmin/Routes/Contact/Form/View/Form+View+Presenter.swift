import ContactModule
import FeatherWebAdmin

extension ContactModule.Form.View {
    enum Presenter {}
}

extension ContactModule.Form.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            item: ContactForm.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
