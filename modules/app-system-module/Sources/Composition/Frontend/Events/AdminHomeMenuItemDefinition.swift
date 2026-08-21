import FeatherContracts

public struct AdminHomeMenuItemDefinition: Sendable {
    public let label: String
    public let addLabel: String
    public let addHref: String
    public let manageLabel: String
    public let manageHref: String
    public let createPermission: String
    public let listPermission: String

    public init(
        label: String,
        addLabel: String,
        addHref: String,
        manageLabel: String,
        manageHref: String,
        createPermission: String,
        listPermission: String
    ) {
        self.label = label
        self.addLabel = addLabel
        self.addHref = addHref
        self.manageLabel = manageLabel
        self.manageHref = manageHref
        self.createPermission = createPermission
        self.listPermission = listPermission
    }
}
