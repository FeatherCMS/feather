import FeatherOpenAPI

extension Email.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasList" }
        var items: (any SchemaRepresentable)? {
            Email.Get.Schema().reference()
        }
    }
}
