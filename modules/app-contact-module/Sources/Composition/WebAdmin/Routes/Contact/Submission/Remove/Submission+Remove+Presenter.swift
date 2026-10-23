import ContactApplication
import ContactModule
import FeatherWebAdmin

extension Submission.Remove {
    enum Presenter {}
}

extension Submission.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(items: [AdminRemoveItemContext])
            async throws -> HTMLResponse
    }
}
