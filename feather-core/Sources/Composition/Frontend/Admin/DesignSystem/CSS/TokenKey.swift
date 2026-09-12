import CSS

/// Design-system token keys
public enum TokenKey {

    public enum Colors {

        public enum Palette {

            public enum Red: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-red-" + rawValue
                }
            }

            public enum Blue: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-blue-" + rawValue
                }
            }

            public enum Green: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-green-" + rawValue
                }
            }

            public enum Yellow: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-yellow-" + rawValue
                }
            }

            public enum Orange: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-orange-" + rawValue
                }
            }

            public enum Purple: String, CSSVariableNameRepresentable {
                case border
                case foreground
                case background
                case text

                public var propertyName: String {
                    "color-purple-" + rawValue
                }
            }
        }

        public enum Link: String, CSSVariableNameRepresentable {
            case `default`
            case hover
            case visited
            case active

            public var propertyName: String {
                "link-color-" + rawValue
            }
        }

        public enum Materials {

            public enum Primary: String, CSSVariableNameRepresentable {
                case tint
                case border
                case text
                case hover

                public var propertyName: String {
                    "material-color-primary-" + rawValue
                }
            }

            public enum Secondary: String, CSSVariableNameRepresentable {
                case tint
                case border
                case text
                case hover

                public var propertyName: String {
                    "material-color-secondary-" + rawValue
                }
            }

            public enum Tertiary: String, CSSVariableNameRepresentable {
                case tint
                case border
                case text
                case hover

                public var propertyName: String {
                    "material-color-tertiary-" + rawValue
                }
            }
        }

        public enum Accents {

            public enum Primary: String, CSSVariableNameRepresentable {
                case tint
                case border
                case hover
                case text

                public var propertyName: String {
                    "accent-color-primary-" + rawValue
                }
            }

            public enum Secondary: String, CSSVariableNameRepresentable {
                case tint
                case border
                case hover
                case text

                public var propertyName: String {
                    "accent-color-secondary-" + rawValue
                }
            }
        }

        public enum Buttons {

            public enum Destructive: String, CSSVariableNameRepresentable {
                case tint
                case border
                case hover
                case text

                public var propertyName: String {
                    "destructive-button-color-" + rawValue
                }
            }

            public enum Ghost {
                public enum Primary: String, CSSVariableNameRepresentable {
                    case tint
                    case border
                    case hover
                    case text

                    public var propertyName: String {
                        "ghost-button-color-primary-" + rawValue
                    }
                }

                public enum Secondary: String, CSSVariableNameRepresentable {
                    case tint
                    case border
                    case hover
                    case text

                    public var propertyName: String {
                        "ghost-button-color-secondary-" + rawValue
                    }
                }
            }

            public enum Disabled: String, CSSVariableNameRepresentable {
                case tint
                case border
                case text
                case hover

                public var propertyName: String {
                    "disabled-button-color-" + rawValue
                }
            }
        }

        public enum Selection: String, CSSVariableNameRepresentable {
            case tint
            case text

            public var propertyName: String {
                "selection-color-" + rawValue
            }
        }

        public enum BoxShadow: String, CSSVariableNameRepresentable {
            case tint

            public var propertyName: String {
                "box-shadow-color-" + rawValue
            }
        }
    }
}
