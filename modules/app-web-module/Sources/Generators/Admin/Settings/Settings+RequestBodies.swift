public import FeatherOpenAPI

struct SettingsUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SettingsUpdateSchema().reference())
        ]
    }
}
