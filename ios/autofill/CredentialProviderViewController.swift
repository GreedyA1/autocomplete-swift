//
//  CredentialProviderViewController.swift
//  autofill
//
//  Created by Vakhtang Margvelashvili on 7/9/25.
//

import AuthenticationServices
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }
  
  override func bundleURL() -> URL? {
    #if DEBUG
        let settings = RCTBundleURLProvider.sharedSettings()
        settings.enableDev = true
        settings.enableMinification = false
        if let bundleURL = settings.jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry") {
        if var components = URLComponents(url: bundleURL, resolvingAgainstBaseURL: false) {
            components.queryItems = (components.queryItems ?? []) + [URLQueryItem(name: "autofillExtension", value: "true")]
            return components.url ?? bundleURL
        }
        return bundleURL
        }
        fatalError("Could not create bundle URL")
    #else
        guard let bundleURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") else {
        fatalError("Could not load bundle URL")
        }
        return bundleURL
        Bundle.main.url(forResource: "main", withExtension: "jsbundle")
    #endif
  }
}

class CredentialProviderViewController: ASCredentialProviderViewController {

    /*
     Prepare your UI to list available credentials for the user to choose from. The items in
     'serviceIdentifiers' describe the service the user is logging in to, so your extension can
     prioritize the most relevant credentials in the list.
    */
    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    }

    /*
     Implement this method if your extension supports showing credentials in the QuickType bar.
     When the user selects a credential from your app, this method will be called with the
     ASPasswordCredentialIdentity your app has previously saved to the ASCredentialIdentityStore.
     Provide the password by completing the extension request with the associated ASPasswordCredential.
     If using the credential would require showing custom UI for authenticating the user, cancel
     the request with error code ASExtensionError.userInteractionRequired.

    override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
        let databaseIsUnlocked = true
        if (databaseIsUnlocked) {
            let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
            self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
        } else {
            self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code:ASExtensionError.userInteractionRequired.rawValue))
        }
    }
    */

    /*
     Implement this method if provideCredentialWithoutUserInteraction(for:) can fail with
     ASExtensionError.userInteractionRequired. In this case, the system may present your extension's
     UI and call this method. Show appropriate UI for authenticating the user then provide the password
     by completing the extension request with the associated ASPasswordCredential.

    override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
    }
    */

    @IBAction func cancel(_ sender: AnyObject?) {
        self.extensionContext.cancelRequest(withError: NSError(domain: ASExtensionErrorDomain, code: ASExtensionError.userCanceled.rawValue))
    }

    @IBAction func passwordSelected(_ sender: AnyObject?) {
        let passwordCredential = ASPasswordCredential(user: "j_appleseed", password: "apple1234")
        self.extensionContext.completeRequest(withSelectedCredential: passwordCredential, completionHandler: nil)
    }

    private func loadReactNativeContent() {
        getShareData { [weak self] sharedData in
        guard let self = self else {
            print("❌ Self was deallocated")
            return
        }
        
        reactNativeFactoryDelegate = ReactNativeDelegate()
        reactNativeFactoryDelegate!.dependencyProvider = RCTAppDependencyProvider()
        reactNativeFactory = RCTReactNativeFactory(delegate: reactNativeFactoryDelegate!)
        
        var initialProps = sharedData ?? [:]
        
        // Capture current view's properties before replacing it
        let currentBounds = self.view.bounds
        let currentScale = UIScreen.main.scale
        
        // Log the scale of the parent view
        print("[ShareExtension] self.view.contentScaleFactor before adding subview: \(self.view.contentScaleFactor)")
        print("[ShareExtension] UIScreen.main.scale: \(currentScale)")
        
        // Add screen metrics to initial properties for React Native
        // These can be used by the JS side to understand its container size and scale
        initialProps["initialViewWidth"] = currentBounds.width
        initialProps["initialViewHeight"] = currentBounds.height
        initialProps["pixelRatio"] = currentScale
        // It's also good practice to pass the font scale for accessibility
        // Default body size on iOS is 17pt, used as a reference for calculating fontScale.
        initialProps["fontScale"] = UIFont.preferredFont(forTextStyle: .body).pointSize / 17.0
        
        // Create the React Native root view
        let reactNativeRootView = reactNativeFactory!.rootViewFactory.view(
            withModuleName: "autofillExtension",
            initialProperties: initialProps
        )
        
        let backgroundFromInfoPlist = Bundle.main.object(forInfoDictionaryKey: "ShareExtensionBackgroundColor") as? [String: CGFloat]
        let heightFromInfoPlist = Bundle.main.object(forInfoDictionaryKey: "ShareExtensionHeight") as? CGFloat
        
        configureRootView(reactNativeRootView, withBackgroundColorDict: backgroundFromInfoPlist, withHeight: heightFromInfoPlist)
        view.addSubview(reactNativeRootView)

        // Hide loading indicator once React content is ready
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
        }
    }

    private func configureRootView(_ rootView: UIView, withBackgroundColorDict dict: [String: CGFloat]?, withHeight: CGFloat?) {
        rootView.backgroundColor = backgroundColor(from: dict)

        // Get the screen bounds
        let screenBounds = UIScreen.main.bounds

        // Calculate proper frame
        let frame: CGRect
        if let withHeight = withHeight {
        rootView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        frame = CGRect(
            x: 0,
            y: screenBounds.height - withHeight,
            width: screenBounds.width,
            height: withHeight
        )
        } else {
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frame = screenBounds
        }
        rootView.frame = frame
    }

}
