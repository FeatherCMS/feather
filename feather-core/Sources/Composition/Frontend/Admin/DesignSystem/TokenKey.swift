import CSS

/// Design-system token keys
public enum TokenKey {

    public enum Colors {

        public enum Text: String, CSSVariableNameRepresentable {
            case primary
            case secondary
            case tertiary
            case muted

            public var propertyName: String {
                "text-color-" + rawValue
            }
        }

        public enum Background: String, CSSVariableNameRepresentable {
            case primary
            case secondary
            case tertiary
            case muted

            public var propertyName: String {
                "background-color-" + rawValue
            }
        }

        public enum Border: String, CSSVariableNameRepresentable {
            case primary
            case secondary
            case tertiary
            case muted

            public var propertyName: String {
                "border-color-" + rawValue
            }
        }

        public enum Link: String, CSSVariableNameRepresentable {
            case `default`
            case secondary
            case hover
            case visited
            case active

            public var propertyName: String {
                let prefix = "link-color"
                switch self {
                case .default:
                    return prefix
                default:
                    return prefix + "-" + rawValue
                }
            }
        }

        public enum Accent: String, CSSVariableNameRepresentable {
            case primary
            case secondary
            case tertiary
            case muted

            public var propertyName: String {
                let prefix = "accent-color"
                switch self {
                case .primary:
                    return prefix
                default:
                    return prefix + "-" + rawValue
                }
            }
        }

        public enum Selection: String, CSSVariableNameRepresentable {
            case `default`

            public var propertyName: String {
                switch self {
                case .default: "selection-color"
                }
            }
        }

        public enum BoxShadow: String, CSSVariableNameRepresentable {
            case `default`

            public var propertyName: String {
                "box-shadow-color"
            }
        }
    }
}
