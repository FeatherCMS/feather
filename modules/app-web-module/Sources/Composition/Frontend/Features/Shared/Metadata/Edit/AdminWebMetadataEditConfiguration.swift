public import FeatherWebAdmin

public struct AdminWebMetadataEditConfiguration: Sendable {
    public let referenceType: String

    public let title: String
    public let description: String
    public let breadcrumb: [AdminBreadcrumb.Link]
    public let navigationTabs: [AdminTabBar.Link]

    public init(
        referenceType: String,
        title: String,
        description: String = "Edit the web metadata for the content.",
        breadcrumb: [AdminBreadcrumb.Link],
        navigationTabs: [AdminTabBar.Link]
    ) {
        self.referenceType = referenceType
        self.title = title
        self.description = description
        self.breadcrumb = breadcrumb
        self.navigationTabs = navigationTabs
    }
}
