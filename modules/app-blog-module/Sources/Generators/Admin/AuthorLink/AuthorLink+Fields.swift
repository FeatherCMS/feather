import FeatherOpenAPI

struct BlogAuthorLinkIdField: StringSchemaRepresentable {
    var example: String? = "wmi_home"
}

struct BlogAuthorLinkLabelField: StringSchemaRepresentable {
    var example: String? = "Home"
}

struct BlogAuthorLinkURLField: StringSchemaRepresentable {
    var example: String? = "/"
}

struct BlogAuthorLinkPriorityField: IntSchemaRepresentable {
    var example: Int? = 10
}

struct BlogAuthorLinkIsBlankField: BoolSchemaRepresentable {
    var example: Bool? = false
}

struct BlogAuthorLinkPermissionField: StringSchemaRepresentable {
    var example: String? = ""
}

struct BlogAuthorLinkNotesField: StringSchemaRepresentable {
    var example: String? = "Visible for all visitors."
}

struct BlogAuthorLinkUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "label,url"
}

struct BlogAuthorLinkCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorLinkUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}
