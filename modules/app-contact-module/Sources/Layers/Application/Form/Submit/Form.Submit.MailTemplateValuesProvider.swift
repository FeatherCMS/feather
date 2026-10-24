public import FeatherModuleKit
import ContactModule

extension Form.Submit {
    public struct MailTemplateValuesProvider: Event {
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
