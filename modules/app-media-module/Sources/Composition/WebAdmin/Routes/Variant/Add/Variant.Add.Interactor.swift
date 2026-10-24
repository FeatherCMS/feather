import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Add {
    enum Interactor {}
}

extension Variant.Add.Interactor {
    protocol Interface: Sendable {
        func add(input: Variant.Form.Input) async throws
    }
}
