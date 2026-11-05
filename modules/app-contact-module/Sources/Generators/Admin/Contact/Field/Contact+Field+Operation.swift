import FeatherOpenAPI

extension Contact.Field {
    protocol Operation: Contact.Operation {}
    protocol IDOperation: Operation {}
}

extension Contact.Field.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [Contact.Field.Parameters.ID().reference()]
    }
}
