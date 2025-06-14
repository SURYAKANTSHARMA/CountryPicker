import Foundation

// A class that's definitely part of your framework/module.
// If `Country` is a very generic class name and might exist elsewhere,
// pick a more unique class name from your module.
// For this example, assuming `Country` is suitable.
// If not, replace `Country.self` with e.g. `CountryManager.self` or another specific class.
class FrameworkAnchorClass {
    // This class is just used to anchor the Bundle lookup.
    // For example, Country.self or CountryManager.self or any other class defined in your module.
}

public struct AccessibilityUtil {
    public static var pickerAccessibilityBundle: Bundle {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            // Ensure FrameworkAnchorClass is a class defined within your framework/module
            // to correctly locate the bundle in non-SPM environments.
            return Bundle(for: FrameworkAnchorClass.self)
        #endif
    }
}
