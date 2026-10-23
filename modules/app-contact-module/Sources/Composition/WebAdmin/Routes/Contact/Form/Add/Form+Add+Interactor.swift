import ContactApplication
import ContactModule
import FeatherWebShared

extension Form.Add {
    enum Interactor {}
}

extension Form.Add.Interactor {
    protocol Interface: Sendable {
        func availableFields() async throws -> [AdminContactFormFieldOption]

        func create(entity: Form.Add.Model) async throws
            -> AdminContactFormDetailsItem
    }
}
