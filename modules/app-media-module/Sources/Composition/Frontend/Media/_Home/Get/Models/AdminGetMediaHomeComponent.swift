import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetMediaHomeComponent: Leaf {
    func html() -> some BasicTag {
        Section {
            Nav {
                Ol {
                    Li { A("Admin").href("/admin/") }
                    Li("Media").ariaCurrent(.page)
                }
            }
            .class("cms-breadcrumb")
            .ariaLabel("Breadcrumb")

            H1("Media management")
            Ul {
                Li { A("Assets").href("/admin/media/assets/") }
                Li { A("Processors").href("/admin/media/processors/") }
            }
        }
        .class("cms-section")
    }
}
