import FeatherOpenAPI

extension Settings.Schemas {
    struct HomePageID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsHomePageIDField" }
        var example: String? { "web_page_1" }
    }
}
