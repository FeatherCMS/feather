import FeatherAdmin

public struct AdminWebMetadataEditConfiguration: Sendable {
    public let title: String
    public let breadcrumb: AdminBreadcrumb.State

    public init(
        title: String,
        breadcrumb: AdminBreadcrumb.State
    ) {
        self.title = title
        self.breadcrumb = breadcrumb
    }
}
