public import ContactModule
public import FeatherModuleKit

extension Form.Submit {
    public struct MailTemplateValuesProvider: FeatherModuleKit.Event {
        public let formKey: String

        public struct Output: Sendable {
            public let values: [String: String]

            public init(values: [String: String]) {
                self.values = values
            }
        }

        public init(formKey: String) {
            self.formKey = formKey
        }
    }
}
