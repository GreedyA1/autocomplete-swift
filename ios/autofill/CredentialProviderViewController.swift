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
  private var reactNativeFactory: RCTReactNativeFactory?
  private var reactNativeFactoryDelegate: RCTReactNativeFactoryDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup React Native delegate
    reactNativeFactoryDelegate = ReactNativeDelegate()
    reactNativeFactoryDelegate!.dependencyProvider = RCTAppDependencyProvider()
    reactNativeFactory = RCTReactNativeFactory(delegate: reactNativeFactoryDelegate!)

    let screenScale = UIScreen.main.scale
    let screenBounds = self.view.bounds

    let initialProps: [String: Any] = [
      "initialViewWidth": screenBounds.width,
      "initialViewHeight": screenBounds.height,
      "pixelRatio": screenScale,
      "fontScale": UIFont.preferredFont(forTextStyle: .body).pointSize / 17.0
    ]

    let rootView = reactNativeFactory!.rootViewFactory.view(
      withModuleName: "autofillExtension",
      initialProperties: initialProps
    )
    
    rootView.frame = self.view.bounds
    rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.view.addSubview(rootView)
  }

  override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
    // Called when the user opens the Autofill sheet — optional to customize
  }

  override func provideCredentialWithoutUserInteraction(for credentialIdentity: ASPasswordCredentialIdentity) {
    // Auto-fill credential without showing UI — optional
  }

  override func prepareInterfaceToProvideCredential(for credentialIdentity: ASPasswordCredentialIdentity) {
    // Provide UI for selected credential if needed
  }

  // Proper teardown if needed
  deinit {
    reactNativeFactory = nil
    reactNativeFactoryDelegate = nil
  }
}
