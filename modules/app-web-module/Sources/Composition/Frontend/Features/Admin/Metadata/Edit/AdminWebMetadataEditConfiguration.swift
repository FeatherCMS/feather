import FeatherAdmin

public struct AdminWebMetadataEditConfiguration: Sendable {
    public let title: String
    public let breadcrumb: [NewAdminBreadcrumb.Link]

    public init(
        title: String,
        breadcrumb: [NewAdminBreadcrumb.Link]
    ) {
        self.title = title
        self.breadcrumb = breadcrumb
    }
}
