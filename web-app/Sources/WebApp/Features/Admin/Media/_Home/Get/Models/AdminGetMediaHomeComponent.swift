import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetMediaHomeComponent: Component {
    func content() -> some BasicTag {
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
