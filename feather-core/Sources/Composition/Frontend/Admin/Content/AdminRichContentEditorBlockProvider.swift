public import FeatherContracts

public struct AdminRichContentEditorBlockDefinition: Codable, Hashable, Sendable {
    public enum Editor: String, Codable, Hashable, Sendable {
        case reference
        case text
        case marker
    }

    public let type: String
    public let title: String
    public let icon: String
    public let directive: String
    public let argument: String
    public let editor: Editor
    public let pickerEndpoint: String?
    public let isContainer: Bool
    public let isContainerChild: Bool

    public init(
        type: String,
        title: String,
        icon: String,
        directive: String,
        argument: String = "key",
        editor: Editor = .reference,
        pickerEndpoint: String? = nil,
        isContainer: Bool = false,
        isContainerChild: Bool = false
    ) {
        self.type = type
        self.title = title
        self.icon = icon
        self.directive = directive
        self.argument = argument
        self.editor = editor
        self.pickerEndpoint = pickerEndpoint
        self.isContainer = isContainer
        self.isContainerChild = isContainerChild
    }
}

public struct AdminRichContentEditorBlockProvider: Event {
    public typealias Output = AdminRichContentEditorBlockDefinition?

    public init() {}
}
