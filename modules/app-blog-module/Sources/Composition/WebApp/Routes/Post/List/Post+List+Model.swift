import BlogAppAPI
public import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

extension Post.List {
    public struct Model: Sendable {
        public let title: String
        public let items: [Post.Summary.Model]

        public init(title: String, items: [Post.Summary.Model]) {
            self.title = title
            self.items = items
        }
    }
}
