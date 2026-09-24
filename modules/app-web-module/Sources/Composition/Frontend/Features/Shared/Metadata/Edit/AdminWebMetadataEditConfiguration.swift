public import FeatherAdmin

public struct AdminWebMetadataEditConfiguration: Sendable {
    public let referenceType: String

    public let title: String
    public let description: String
    public let breadcrumb: [NewAdminBreadcrumb.Link]
    public let navigationTabs: [NewAdminTabBar.Link]

    public init(
        referenceType: String,
        title: String,
        description: String = "Edit the web metadata for the content.",
        breadcrumb: [NewAdminBreadcrumb.Link],
        navigationTabs: [NewAdminTabBar.Link]
    ) {
        self.referenceType = referenceType
        self.title = title
        self.description = description
        self.breadcrumb = breadcrumb
        self.navigationTabs = navigationTabs
    }
}
