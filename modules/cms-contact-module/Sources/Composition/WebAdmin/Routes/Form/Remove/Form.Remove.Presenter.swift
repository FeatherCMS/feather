import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared

extension ContactModule.Form.Remove {
    enum Presenter {}
}

extension ContactModule.Form.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(items: [AdminRemoveItemContext])
            async throws -> HTMLResponse
    }
}
