import Domain
import struct Foundation.Date

public struct ContactFormItem: Model {

    public static let globalFormId = "__global_contact_fields__"

    public enum ItemType: String, Sendable, CaseIterable, Codable {
        case text
        case textarea
        case select
        case radio
        case toggle
    }

    public struct Option: Codable, Sendable, Equatable {
        public let value: String
        public let label: String

        public init(
            value: String,
            label: String
        ) {
            self.value = value
            self.label = label
        }
    }

    public enum Error: DomainError {
        case keyTooShort
        case keyTooLong
        case labelTooShort
        case labelTooLong
        case optionsRequired
        case optionsNotAllowed
    }

    public struct New: Sendable {
        public let id: String
        public let formId: String
        public let key: String
        public let type: ItemType
        public let label: String
        public let allowedValues: [Option]
        public let isRequired: Bool
        public let position: Int
    }

    public let id: String
    public let formId: String
    public var key: String
    public var type: ItemType
    public var label: String
    public var allowedValues: [Option]
    public var isRequired: Bool
    public var position: Int
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        key: String,
        type: ItemType,
        label: String,
        allowedValues: [Option],
        isRequired: Bool,
        position: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.formId = formId
        self.key = key
        self.type = type
        self.label = label
        self.allowedValues = allowedValues
        self.isRequired = isRequired
        self.position = position
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension ContactFormItem {

    private static func validate(
        key: String,
        label: String,
        type: ItemType,
        allowedValues: [Option]
    ) throws(Self.Error) {
        guard !key.isEmpty else { throw .keyTooShort }
        guard key.count < 128 else { throw .keyTooLong }
        guard !label.isEmpty else { throw .labelTooShort }
        guard label.count < 255 else { throw .labelTooLong }

        switch type {
        case .select, .radio:
            guard !allowedValues.isEmpty else { throw .optionsRequired }
        case .text, .textarea, .toggle:
            guard allowedValues.isEmpty else { throw .optionsNotAllowed }
        }
    }

    static func create(
        id: String,
        formId: String,
        key: String,
        type: ItemType,
        label: String,
        allowedValues: [Option] = [],
        isRequired: Bool = false,
        position: Int = 0
    ) throws(Self.Error) -> Self.New {
        try validate(
            key: key,
            label: label,
            type: type,
            allowedValues: allowedValues
        )
        return .init(
            id: id,
            formId: formId,
            key: key,
            type: type,
            label: label,
            allowedValues: allowedValues,
            isRequired: isRequired,
            position: position
        )
    }

    mutating func update(
        key: String? = nil,
        type: ItemType? = nil,
        label: String? = nil,
        allowedValues: [Option]? = nil,
        isRequired: Bool? = nil,
        position: Int? = nil
    ) throws(Self.Error) {
        let newKey = key ?? self.key
        let newType = type ?? self.type
        let newLabel = label ?? self.label
        let newAllowedValues = allowedValues ?? self.allowedValues
        try Self.validate(
            key: newKey,
            label: newLabel,
            type: newType,
            allowedValues: newAllowedValues
        )
        self.key = newKey
        self.type = newType
        self.label = newLabel
        self.allowedValues = newAllowedValues
        self.isRequired = isRequired ?? self.isRequired
        self.position = position ?? self.position
    }
}
