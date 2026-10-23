import ContactApplication
import ContactModule
import FeatherWebShared

extension Form.Add {
    enum Repository {}
}

extension Form.Add.Repository {
    protocol Interface: Sendable {
        func availableFields() async throws -> [ContactForm.Field.Option]

        func create(entity: Form.Add.Model) async throws
            -> ContactForm.Details.Item
    }
}
