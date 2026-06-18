import Application
import WebDomain
import SystemApplication
import WebDomain

public struct WritePageMetadata: Scope {
    public let page: any PageRepository
    public let metadata: any MetadataRepository
    public let settings: any SettingsRepository
    public let variable: any VariableQueries

    public init(
        page: any PageRepository,
        metadata: any MetadataRepository,
        settings: any SettingsRepository,
        variable: any VariableQueries
    ) {
        self.page = page
        self.metadata = metadata
        self.settings = settings
        self.variable = variable
    }
}
