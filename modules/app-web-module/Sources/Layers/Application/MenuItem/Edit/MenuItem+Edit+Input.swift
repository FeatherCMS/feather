public import FeatherApplication
public import FeatherDomain
public import WebDomain
public import WebModule

extension MenuItem.Edit {
    public struct Input: DTO {
        public let id: String
        public let menuId: String
        public let label: FieldChange<String>
        public let url: FieldChange<String>
        public let priority: FieldChange<Int>
        public let isBlank: FieldChange<Bool>
        public let permission: FieldChange<String>
        public let authentication: FieldChange<MenuItem.Model.Authentication>
        public let notes: OptionalFieldChange<String>

        public init(
            id: String,
            menuId: String,
            label: FieldChange<String> = .unchanged,
            url: FieldChange<String> = .unchanged,
            priority: FieldChange<Int> = .unchanged,
            isBlank: FieldChange<Bool> = .unchanged,
            permission: FieldChange<String> = .unchanged,
            authentication: FieldChange<MenuItem.Model.Authentication> = .unchanged,
            notes: OptionalFieldChange<String> = .unchanged
        ) {
            self.id = id
            self.menuId = menuId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.authentication = authentication
            self.notes = notes
        }
    }
}
