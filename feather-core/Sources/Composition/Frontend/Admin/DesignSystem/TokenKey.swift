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

        public enum Accent {
            public enum Primary: String, CSSVariableNameRepresentable {
                case `default`
                case hover

                public var propertyName: String {
                    "accent-color-primary" + (self == .default ? "" : "-hover")
                }
            }

            public enum Secondary: String, CSSVariableNameRepresentable {
                case `default`
                case hover

                public var propertyName: String {
                    "accent-color-secondary" + (self == .default ? "" : "-hover")
                }
            }

        }

        public enum Destructive: String, CSSVariableNameRepresentable {
            case `default`
            case hover

            public var propertyName: String {
                let prefix = "destructive-color"
                switch self {
                case .default:
                    return prefix
                case .hover:
                    return prefix + "-hover"
                }
            }
        }

        public enum Ghost {
            public enum Primary: String, CSSVariableNameRepresentable {
                case `default`
                case hover

                public var propertyName: String {
                    "ghost-color-primary" + (self == .default ? "" : "-hover")
                }
            }

            public enum Secondary: String, CSSVariableNameRepresentable {
                case `default`
                case hover

                public var propertyName: String {
                    "ghost-color-secondary" + (self == .default ? "" : "-hover")
                }
            }
        }

        public enum Button {
            public enum Disabled: String, CSSVariableNameRepresentable {
                case background
                case border
                case text

                public var propertyName: String {
                    "button-disabled-" + rawValue
                }
            }
        }

        public enum Selection: String, CSSVariableNameRepresentable {
            case primary
            case secondary
            case tertiary
            case muted
            case text

            public var propertyName: String {
                "selection-color-" + rawValue
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
