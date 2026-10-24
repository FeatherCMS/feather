import FeatherOpenAPI
import OpenAPIKit30

extension Email.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasList" }
        var items: (any SchemaRepresentable)? {
            Email.Get.Schema().reference()
        }
    }
}
