import ContactApplication
import ContactModule
import FeatherWebAdmin

extension Form.Search {
    enum Presenter {}
}

extension Form.Search.Presenter {
    protocol Interface: Sendable {
        func renderSearch(
            items: [Form.Search.Model.Item],
            total: Int,
            search: String,
            isPicker: Bool,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
