struct AdminEditWebSettingsModel: Sendable {
    let logo: String
    let logoDark: String
    let metaImage: String
    let primaryColor: String
    let secondaryColor: String
    let tertiaryColor: String
    let primaryFont: String
    let secondaryFont: String
    let homePageId: String?
    let homePage: AdminEditWebSettingsHomePageModel?
    let homePageOptions: [AdminEditWebSettingsHomePageModel]
    let locale: String
    let timezone: String
    let title: String
    let excerpt: String
    let noIndex: Bool
    let css: String
    let js: String
    let hasMissingVariables: Bool
}
