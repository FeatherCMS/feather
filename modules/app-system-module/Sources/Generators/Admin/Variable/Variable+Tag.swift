import FeatherOpenAPI

extension Variable {
    struct Tag: TagRepresentable {
        var name: String = "SystemVariables"
        var description: String? = "Manage system variables."
    }
}
