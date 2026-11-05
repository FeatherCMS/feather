import FeatherOpenAPI

extension Variable.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemVariableUpdateMask" }
        var example: String? = "key,value,name,notes"
    }
}
