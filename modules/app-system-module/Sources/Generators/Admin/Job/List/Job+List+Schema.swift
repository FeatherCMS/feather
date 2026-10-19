import FeatherOpenAPI

extension Job.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobListSchema" }
        var items: (any SchemaRepresentable)? {
            Job.Get.Schema().reference()
        }
    }
}
