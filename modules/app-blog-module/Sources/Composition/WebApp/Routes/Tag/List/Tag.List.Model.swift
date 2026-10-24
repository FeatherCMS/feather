import BlogAppAPI
public import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebApp

extension Tag.List {
    public struct Model: Sendable {
        public let title: String
        public let items: [Tag.Summary.Model]

        public init(title: String, items: [Tag.Summary.Model]) {
            self.title = title
            self.items = items
        }
    }
}
