extension Template {
    public struct Field: Sendable, Equatable {
        public enum Editor: Sendable, Equatable {
            case input
            case textarea
        }

        public indirect enum Kind: Sendable, Equatable {
            case string
            case boolean
            case integer
            case float
            case double
            case date
            case object([Field])
            case list(Kind)
        }

        public let key: String
        public let title: String
        public let kind: Kind
        public let editor: Editor
        public let required: Bool
        public let defaultValue: Value?

        public init(
            key: String,
            title: String,
            kind: Kind,
            required: Bool = false,
            defaultValue: Value? = nil,
            editor: Editor = .input
        ) {
            self.key = key
            self.title = title
            self.kind = kind
            self.editor = editor
            self.required = required
            self.defaultValue = defaultValue
        }
    }
}
