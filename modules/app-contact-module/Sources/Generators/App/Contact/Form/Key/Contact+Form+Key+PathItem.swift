import FeatherOpenAPI

extension Contact.Form.Key {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Contact.Form.Get.Operation()
        }
    }
}

extension Contact.Form {
    enum Key {}
}
