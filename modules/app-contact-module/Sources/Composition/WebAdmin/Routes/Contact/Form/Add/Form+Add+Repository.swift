import ContactApplication
import ContactModule
import ContactWebShared

extension Form.Add {
    enum Repository {}
}

extension Form.Add.Repository {
    protocol Interface: Sendable {
        func availableFields() async throws -> [AdminContactFormFieldOption]

        func create(entity: Form.Add.Model) async throws
            -> AdminContactFormDetailsItem
    }
}
