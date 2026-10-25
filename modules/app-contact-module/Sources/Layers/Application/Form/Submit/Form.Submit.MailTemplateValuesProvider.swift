public import FeatherModuleKit
public import ContactModule

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
