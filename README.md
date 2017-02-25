Swyft API SDK (iOS)
===================
The SDK handles the following on behalf of the implementor.  By doing so, it should cut down the time required to implement from a few days to a few hours.

**Features**

1. Abstracts away low-level HTTP requests calls
2. Abstracts away authentication
3. Handles known API parameters

**It has the following dependencies**

1. SwiftyJSON - JSON parser (https://github.com/SwiftyJSON/SwiftyJSON)

**Still needs the following (TODO):**

1. Client data collection (see below)
2. Objective-C implementation
3. Testing, testing, testing - SDK cannot cause fatal errors as it will crash the application

**It would be nice to have the following for release**

1. Podfile install
2. Dependency removal

Implementation instructions
---------------------------
1. Under the target’s General tab, add the SwyftSDK.framework in "Embedded Binaries" section. Select "Copy items if needed".
2. Add granttype,clientsecret,clientid in Project Info.plist.
3. Import the SDK (‘import SwyftSDK’)

From there the following methods are available
----------------------------------------------
```
SwyftSDK.sharedInstance.getAllAssets { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getTrendingAssets { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getCategories { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getCategory(forCategoryId: categoryId) { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getCategoryAssets(forCategoryId: categoryId) { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getAllPacks { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getPack(forPackId: packId) { (response, error) in

}
```

```
SwyftSDK.sharedInstance.getAllAssets(forPackId: packId) { (response, error) in

}
```

Client/Device data collection
-----------------------------
Using a library like this one: https://github.com/Shmoopi/iOS-System-Services, we can easily collect information about the user's device in the background.  Here are the parts of the library that would be useful for analytics:

**Hardware Information**  
NSString *deviceModel; // Model of Device  
NSString *deviceName; // Device Name  
NSString *systemName; // System Name  
NSString *systemsVersion; // System Version  
NSString *systemDeviceTypeFormatted; // System Device Type (Formatted = iPhone 1)  
NSInteger screenWidth; // Get the Screen Width (X)  
NSInteger screenHeight; // Get the Screen Height (Y)  
BOOL multitaskingEnabled; // Multitasking enabled?  

**Carrier Information**  
NSString *carrierName; // Carrier Name  
NSString *carrierCountry; // Carrier Country  
NSString *carrierISOCountryCode; // Carrier ISO Country Code  
NSString *carrierMobileNetworkCode; // Carrier Mobile Network Code  

**Network Information**  
NSString *externalIPAddress; // Get External IP Address  
BOOL connectedToWiFi; // Connected to WiFi?  
BOOL connectedToCellNetwork; // Connected to Cellular Network?  

**Localization Information**  
NSString *country; // Country  
NSString *language; // Language  
NSString *timeZoneSS; // TimeZone  
NSString *currency; // Currency Symbol  

**Application Information**
NSString *applicationVersion; // Application Version  

**Universal Unique Identifiers**  
NSString *uniqueID; // Unique ID  
NSString *deviceSignature; // Device Signature  
NSString *cfuuid; // CFUUID  
