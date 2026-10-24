import BlogAppAPI
public import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

extension Author.List {
    public struct Model: Sendable {
        public let title: String
        public let items: [Author.Summary.Model]

        public init(title: String, items: [Author.Summary.Model]) {
            self.title = title
            self.items = items
        }
    }
}
