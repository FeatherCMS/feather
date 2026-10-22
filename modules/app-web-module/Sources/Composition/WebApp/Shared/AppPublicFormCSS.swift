public import CSS
public import HTML
import WebBuilders
public import WebComponents

public struct AppPublicFormCSS: Component {
    public init() {}

    public func html(context: inout BuilderContext) -> Div {
        Div {}
    }

    public func selectors() -> [any CSS.Selector] {
        Custom(".contact-form, .newsletter-subscription-form") {
            Display(.flex)
            FlexDirection(.column)
            AlignItems(.flexStart)
        }
        Custom(".contact-form") {
            Gap(.length(30.px), .length(30.px))
            Width(100.percent)
        }
        Custom(".newsletter-subscription-form") {
            Gap(.length(12.px), .length(12.px))
            MaxWidth(.length(400.px))
            Width(100.percent)
        }
        Custom(".contact-form-field, .newsletter-subscription-form > label") {
            Display(.flex)
            FlexDirection(.column)
            AlignItems(.flexStart)
            Gap(.length(8.px), .length(8.px))
        }
        Custom(".contact-form-field") {
            Width(100.percent)
        }
        Custom(".newsletter-subscription-form > label") {
            Width(100.percent)
        }
        Custom(
            ".contact-form-field input:not([type='radio']):not([type='checkbox']), .contact-form-field select, .contact-form-field textarea, .newsletter-subscription-form input[type='email']"
        ) {
            Display(.block)
            BoxSizing(.borderBox)
            Width(100.percent)
            MaxWidth(.length(400.px))
            MinHeight(.length(44.px))
            Border(.values(.length(1.px), .solid, .color("#B2B2B2")))
            BorderRadius(.length(6.px, nil, nil, nil))
            Padding(top: 8.px, right: 16.px, bottom: 8.px, left: 16.px)
            BackgroundColor(.color("#FFFFFF"))
            FontSize(.length(16.px))
            LineHeight(.length(24.px))
        }
        Custom(
            ".contact-form-field textarea"
        ) {
            MinHeight(.length(120.px))
            Resize(.vertical)
        }
        Custom("fieldset.contact-form-field") {
            Display(.flex)
            FlexDirection(.column)
            Gap(.length(8.px), .length(8.px))
        }
        Custom("fieldset.contact-form-field > label") {
            Display(.flex)
            AlignItems(.center)
            Gap(.length(8.px), .length(8.px))
        }
        Custom(".contact-form-field:has(> input[type='checkbox'])") {
            FlexDirection(.row)
            AlignItems(.center)
        }
        Custom(
            ".contact-form button[type='submit'], .newsletter-subscription-form button[type='submit']"
        ) {
            AlignSelf(.flexStart)
            MinHeight(.length(44.px))
            Padding(vertical: .length(10.px), horizontal: .length(20.px))
            Border(0)
            BorderRadius(.length(6.px, nil, nil, nil))
            BackgroundColor(.color("#333333"))
            Color(.white)
            FontWeight(.w600)
            Cursor(.pointer)
        }
        Custom(".web-form-feedback") {
            BoxSizing(.borderBox)
            Padding(vertical: .length(12.px), horizontal: .length(16.px))
            BorderRadius(.length(6.px, nil, nil, nil))
            Width(100.percent)
        }
        Custom(".web-form-feedback--success") {
            BackgroundColor(.color("#EAF6ED"))
            Color(.color("#1F6B37"))
        }
        Custom(".web-form-feedback--failure") {
            BackgroundColor(.color("#FCEDEC"))
            Color(.color("#A12822"))
        }
    }
}
