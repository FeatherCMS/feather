public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

/// An autocomplete form field containing language codes and display names.
public struct NewAdminFormFieldLanguage: Component {
    public typealias Option = NewAdminFormFieldSelectAutocomplete.Option
    public typealias SelectionMode =
        NewAdminFormFieldSelectAutocomplete.SelectionMode

    public struct State: Sendable {
        public var name: String
        public var label: String
        public var values: [String]
        public var options: [Option]?
        public var placeholder: String?
        public var error: String?
        public var help: String?
        public var isRequired: Bool
        public var isDisabled: Bool
        public var selectionMode: SelectionMode
        public var submitsValues: Bool

        public init(
            name: String,
            label: String,
            values: [String] = [],
            options: [Option]? = nil,
            placeholder: String? = nil,
            error: String? = nil,
            help: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            selectionMode: SelectionMode = .single,
            submitsValues: Bool = true
        ) {
            self.name = name
            self.label = label
            self.values = values
            self.options = options
            self.placeholder = placeholder
            self.error = error
            self.help = help
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.selectionMode = selectionMode
            self.submitsValues = submitsValues
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any CSS.Selector] {
        []
    }

    public func html(context: inout BuilderContext) -> Section {
        let selectedValues = Set(
            state.selectionMode == .single
                ? Array(state.values.prefix(1))
                : state.values
        )
        let options = (state.options ?? Self.options)
            .map {
                Option(
                    label: $0.label,
                    value: $0.value,
                    isSelected: selectedValues.contains($0.value)
                        || selectedValues.contains($0.label)
                )
            }
        return context.build(
            NewAdminFormFieldSelectAutocomplete(
                state: .init(
                    name: state.name,
                    label: state.label,
                    placeholder: state.placeholder
                        ?? defaultPlaceholder,
                    options: options,
                    error: state.error,
                    help: state.help,
                    isRequired: state.isRequired,
                    isDisabled: state.isDisabled,
                    selectionMode: state.selectionMode,
                    submitsValues: state.submitsValues
                )
            )
        )
    }

    public static var options: [Option] {
        languageOptions
    }

    private var defaultPlaceholder: String {
        switch state.selectionMode {
        case .single:
            "Select a language"
        case .multiple:
            "Select one or more languages"
        }
    }

    private static let languageOptions: [Option] =
        [
            .init(label: "Afrikaans", value: "af"),
            .init(label: "Albanian - (Shqip)", value: "sq"),
            .init(label: "Amharic - (አማርኛ)", value: "am"),
            .init(label: "Arabic - (العربية)", value: "ar"),
            .init(label: "Aragonese - (Aragonés)", value: "an"),
            .init(label: "Armenian - (Հայերեն)", value: "hy"),
            .init(label: "Asturian - (Asturianu)", value: "ast"),
            .init(label: "Aymara - (Aymar aru)", value: "ay"),
            .init(label: "Azerbaijani - (Azərbaycan dili)", value: "az"),
            .init(label: "Basque - (Euskara)", value: "eu"),
            .init(label: "Belarusian - (Беларуская)", value: "be"),
            .init(label: "Bengali - (বাংলা)", value: "bn"),
            .init(label: "Bodo - (बर')", value: "brx"),
            .init(label: "Bosnian - (Bosanski)", value: "bs"),
            .init(label: "Breton - (Brezhoneg)", value: "br"),
            .init(label: "Bulgarian - (Български)", value: "bg"),
            .init(label: "Catalan - (Català)", value: "ca"),
            .init(label: "Central - Kurdish (کوردی)", value: "ckb"),
            .init(label: "Chechen (Нохчийн мотт)", value: "ce"),
            .init(label: "Chinese (中文)", value: "zh"),
            .init(label: "Chinese Hong Kong - (中文 - 香港)", value: "zh-HK"),
            .init(label: "Chinese Simplified - (中文简体)", value: "zh-CN"),
            .init(label: "Chinese Traditional - (中文繁體)", value: "zh-TW"),
            .init(label: "Corsican - (Corsu)", value: "co"),
            .init(label: "Croatian - (Hrvatski)", value: "hr"),
            .init(label: "Czech - (Čeština)", value: "cs"),
            .init(label: "Danish - (Dansk)", value: "da"),
            .init(label: "Dhivehi - (ދިވެހި)", value: "dv"),
            .init(label: "Dutch (Nederlands)", value: "nl"),
            .init(label: "Dzongkha (རྫོང་ཁ)", value: "dz"),
            .init(label: "English", value: "en"),
            .init(label: "English (Australia)", value: "en-AU"),
            .init(label: "English (Canada)", value: "en-CA"),
            .init(label: "English (India)", value: "en-IN"),
            .init(label: "English (New Zealand)", value: "en-NZ"),
            .init(label: "English (South Africa)", value: "en-ZA"),
            .init(label: "English (United Kingdom)", value: "en-GB"),
            .init(label: "English (United States)", value: "en-US"),
            .init(label: "Esperanto", value: "eo"),
            .init(label: "Estonian (Eesti)", value: "et"),
            .init(label: "Ewe (Eʋegbe)", value: "ee"),
            .init(label: "Faroese - (Føroyskt)", value: "fo"),
            .init(label: "Filipino (Wikang Filipino)", value: "fil"),
            .init(label: "Finnish (Suomi)", value: "fi"),
            .init(label: "French (Français)", value: "fr"),
            .init(label: "French Canada - (Français Canada)", value: "fr-CA"),
            .init(label: "French France - (Français France)", value: "fr-FR"),
            .init(
                label: "French Switzerland - (Français Suisse)",
                value: "fr-CH"
            ),
            .init(label: "Galician - (Galego)", value: "gl"),
            .init(label: "Georgian - (ქართული)", value: "ka"),
            .init(label: "German - (Deutsch)", value: "de"),
            .init(
                label: "German Austria  - (Deutsch Österreich)",
                value: "de-AT"
            ),
            .init(
                label: "German Germany  - (Deutsch Deutschland)",
                value: "de-DE"
            ),
            .init(
                label: "German Liechtenstein  - (Deutsch Liechtenstein)",
                value: "de-LI"
            ),
            .init(
                label: "German Switzerland  - (Deutsch Schweiz)",
                value: "de-CH"
            ),
            .init(label: "Greek - (Ελληνικά)", value: "el"),
            .init(label: "Guarani - (Avañe'ẽ)", value: "gn"),
            .init(label: "Gujarati - (ગુજરાતી)", value: "gu"),
            .init(label: "Hausa - (هَوُسَ)", value: "ha"),
            .init(label: "Hawaiian - (ʻŌlelo Hawaiʻi)", value: "haw"),
            .init(label: "Hebrew - (עברית)", value: "he"),
            .init(label: "Hindi - (हिन्दी)", value: "hi"),
            .init(label: "Hungarian - (Magyar)", value: "hu"),
            .init(label: "Icelandic - (Íslenska)", value: "is"),
            .init(label: "Indonesian - (Bahasa Indonesia)", value: "id"),
            .init(label: "Interlingua", value: "ia"),
            .init(label: "Inuktitut - (ᐃᓄᒃᑎᑐᑦ)", value: "iu"),
            .init(label: "Irish - (Gaeilge)", value: "ga"),
            .init(label: "Italian - (Italiano)", value: "it"),
            .init(label: "Italian Italy - (Italiano Italia)", value: "it-IT"),
            .init(
                label: "Italian Switzerland - (Italiano - Svizzera)",
                value: "it-CH"
            ),
            .init(label: "Japanese - (日本語)", value: "ja"),
            .init(label: "Kalaallisut - (Kalaallisut)", value: "kl"),
            .init(label: "Kannada - (ಕನ್ನಡ)", value: "kn"),
            .init(label: "Kashmiri - (कॉशुर / كٲشُر‎)", value: "ks"),
            .init(label: "Kazakh - (Қазақ тілі)", value: "kk"),
            .init(label: "Khmer - (ខ្មែរ)", value: "km"),
            .init(label: "Kinyarwanda - (Ikinyarwanda)", value: "rw"),
            .init(label: "Korean - (한국어)", value: "ko"),
            .init(label: "Kurdish - (Kurdî)", value: "ku"),
            .init(label: "Kyrgyz - (Кыргызча)", value: "ky"),
            .init(label: "Lao - (ລາວ)", value: "lo"),
            .init(label: "Latin - (Latina)", value: "la"),
            .init(label: "Latvian - (Latviešu)", value: "lv"),
            .init(label: "Lingala - (Lingála)", value: "ln"),
            .init(label: "Lithuanian - (Lietuvių)", value: "lt"),
            .init(label: "Luganda - (Luganda)", value: "lg"),
            .init(label: "Luxembourgish - (Lëtzebuergesch)", value: "lb"),
            .init(label: "Macedonian - (Македонски)", value: "mk"),
            .init(label: "Maithili - (मैथिली)", value: "mai"),
            .init(label: "Malay - (Bahasa Melayu)", value: "ms"),
            .init(label: "Malayalam - (മലയാളം)", value: "ml"),
            .init(label: "Maltese - (Malti)", value: "mt"),
            .init(label: "Manipuri - (ꯃꯅꯤꯄꯨꯔꯤ)", value: "mni"),
            .init(label: "Marathi - (मराठी)", value: "mr"),
            .init(label: "Mongolian - (Монгол)", value: "mn"),
            .init(label: "Nepali - (नेपाली)", value: "ne"),
            .init(label: "Northern Sotho - (Sesotho sa Leboa)", value: "nso"),
            .init(label: "Norwegian (Norsk)", value: "no"),
            .init(label: "Norwegian Bokmål - (Norsk bokmål)", value: "nb"),
            .init(label: "Norwegian Nynorsk - (Nynorsk)", value: "nn"),
            .init(label: "Occitan", value: "oc"),
            .init(label: "Oriya - (ଓଡ଼ିଆ)", value: "or"),
            .init(label: "Oromo - (Afaan Oromoo)", value: "om"),
            .init(label: "Ossetian - (Ирон æвзаг)", value: "os"),
            .init(label: "Pashto - (پښتو)", value: "ps"),
            .init(label: "Persian - (فارسی)", value: "fa"),
            .init(label: "Polish - (Polski)", value: "pl"),
            .init(label: "Portuguese - (Português)", value: "pt"),
            .init(
                label: "Portuguese Brazil - (Português Brasil)",
                value: "pt-BR"
            ),
            .init(
                label: "Portuguese Portugal - (Português Portugal)",
                value: "pt-PT"
            ),
            .init(label: "Punjabi - (ਪੰਜਾਬੀ)", value: "pa"),
            .init(label: "Quechua - (Runa Simi)", value: "qu"),
            .init(label: "Romanian - (Română)", value: "ro"),
            .init(label: "Romanian  Moldova - (Română Moldova)", value: "mo"),
            .init(label: "Romansh - (Rumantsch)", value: "rm"),
            .init(label: "Russian - (Русский)", value: "ru"),
            .init(label: "Samoan - (Gagana Samoa)", value: "sm"),
            .init(label: "Santali - (ᱥᱟᱱᱛᱟᱲᱤ)", value: "sat"),
            .init(label: "Sardinian - (Sardu)", value: "sc"),
            .init(label: "Scottish Gaelic - (Gàidhlig)", value: "gd"),
            .init(label: "Serbian - (Српски)", value: "sr"),
            .init(label: "Serbo_Croatian - (Srpskohrvatski)", value: "sh"),
            .init(label: "Shona - (ChiShona)", value: "sn"),
            .init(label: "Sindhi - (سنڌي)", value: "sd"),
            .init(label: "Sinhala - (සිංහල)", value: "si"),
            .init(label: "Slovak - (Slovenčina)", value: "sk"),
            .init(label: "Slovenian - (Slovenščina)", value: "sl"),
            .init(label: "Somali - (Soomaali)", value: "so"),
            .init(label: "Southern - Sotho (Sesotho)", value: "st"),
            .init(label: "Spanish - (Español)", value: "es"),
            .init(
                label: "Spanish  Argentina  - (Español Argentina)",
                value: "es-AR"
            ),
            .init(
                label: "Spanish  Latin America  - (Español Latinoamérica)",
                value: "es-419"
            ),
            .init(
                label: "Spanish  Mexico  - (Español  México)",
                value: "es-MX"
            ),
            .init(label: "Spanish  Spain  - (Español España)", value: "es-ES"),
            .init(
                label: "Spanish  United States  - (Español Estados Unidos)",
                value: "es-US"
            ),
            .init(label: "Sundanese - (Basa Sunda)", value: "su"),
            .init(label: "Swahili - (Kiswahili)", value: "sw"),
            .init(label: "Swedish - (Svenska)", value: "sv"),
            .init(label: "Tajik - (Тоҷикӣ)", value: "tg"),
            .init(label: "Tamil - (தமிழ்)", value: "ta"),
            .init(label: "Tatar - (Татар)", value: "tt"),
            .init(label: "Telugu - (తెలుగు)", value: "te"),
            .init(label: "Thai - (ไทย)", value: "th"),
            .init(label: "Tigrinya - (ትግርኛ)", value: "ti"),
            .init(label: "Tongan - (Lea fakatonga)", value: "to"),
            .init(label: "Tswana - (Setswana)", value: "tn"),
            .init(label: "Turkish - (Türkçe)", value: "tr"),
            .init(label: "Turkmen - (Türkmençe)", value: "tk"),
            .init(label: "Twi - (Twi)", value: "tw"),
            .init(label: "Udmurt - (Удмурт кыл)", value: "udm"),
            .init(label: "Ukrainian - (Українська)", value: "uk"),
            .init(label: "Urdu - (اردو)", value: "ur"),
            .init(label: "Uyghur - (ئۇيغۇرچە)", value: "ug"),
            .init(label: "Uzbek - (O'zbek)", value: "uz"),
            .init(label: "Venda - (Tshivenḓa)", value: "ve"),
            .init(label: "Vietnamese - (Tiếng Việt)", value: "vi"),
            .init(label: "Walloon - (Walon)", value: "wa"),
            .init(label: "Welsh - (Cymraeg)", value: "cy"),
            .init(label: "Western Frisian - (Frysk)", value: "fy"),
            .init(label: "Wolof - (Wollof)", value: "wo"),
            .init(label: "Xhosa - (isiXhosa)", value: "xh"),
            .init(label: "Yiddish - (ייִדיש)", value: "yi"),
            .init(label: "Yoruba - (Èdè Yorùbá)", value: "yo"),
            .init(label: "Zhuang - (Saɯ cueŋƅ)", value: "za"),
            .init(label: "Zulu - (isiZulu)", value: "zu"),
        ]
}
