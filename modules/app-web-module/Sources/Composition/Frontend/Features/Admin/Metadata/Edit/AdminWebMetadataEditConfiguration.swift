import FeatherAdmin

public struct AdminWebMetadataEditConfiguration: Sendable {
    public let title: String
    public let description: String
    public let breadcrumb: [NewAdminBreadcrumb.Link]

    public init(
        title: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        description: String =
            "Edit the metadata used when this page is rendered and shared."
    ) {
        self.title = title
        self.description = description
        self.breadcrumb = breadcrumb
    }
}
