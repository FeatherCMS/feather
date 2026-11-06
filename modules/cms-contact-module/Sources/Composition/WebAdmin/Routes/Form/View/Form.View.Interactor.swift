import ContactModule
import FeatherWebAdmin

extension ContactModule.Form.View {
    enum Interactor {}
}

extension ContactModule.Form.View.Interactor {
    protocol Interface: Sendable {
        func get(key: String) async throws -> ContactModule.Form.Details.Item
    }
}
