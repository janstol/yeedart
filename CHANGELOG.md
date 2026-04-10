## [0.4.0] - 2026-04-10
* raised the minimum supported SDK to Dart 3
* updated dependencies
* refreshed package metadata and contributor documentation
* **BC:** fixed typo `LightType.backgroud` → `LightType.background`
* fixed discovery to return empty results when the network is unreachable [#16](https://github.com/janstol/yeedart/issues/16)
* fixed TCP response parsing for fragmented or extra-delimited messages [#18](https://github.com/janstol/yeedart/issues/18)
* fixed stale TCP connection handling by reconnecting and retrying once on dropped sockets [#19](https://github.com/janstol/yeedart/issues/19)
* fixed `DiscoveryResponse` parsing `firmwareVersion` from `port` field instead of `fw_ver`
* fixed `DiscoveryResponse.supportedControls` not splitting on whitespace correctly

## [0.3.2] - 2022-10-22
* Fixed null check [#12](https://github.com/janstol/yeedart/issues/12) and updated all packages [#14](https://github.com/janstol/yeedart/issues/14) (thanks [@guyluz11](https://github.com/guyluz11))

## [0.3.1+2] - 2021-09-28
* dart format

## [0.3.1+1] - 2021-09-28
* lints and formatting fixes

## [0.3.1] - 2021-09-28
* added `Device.connect` method to manually connect to the device

## [0.3.0] - 2021-03-06
* migrated to null-safety

## [0.2.0] - 2020-04-18
* **BC**: removed `Parser`, use `DiscoveryResponse.fromRawResponse` factory constructor instead
* **BC**: removed `Device.onNotificationReceived`, use `Device.notificationMessageStream` stream instead
* **BC**: added `CommandSender.isConnected`, every CommandSender have to implement this getter
* added `Device.isConnected` - returns connection state of command sender (`CommandSender.isConnected`)

## [0.1.2] - 2020-02-15
* bug fix: ssdp:discover quotes [#1](https://github.com/janstol/yeedart/issues/1) ([@fmichenaud](https://github.com/fmichenaud))
* updated dependencies

## [0.1.1] - 2019-12-22
* lint fixes
* updated dependencies

## [0.1.0] - 2019-10-26
* initial version
* added device discovery & controls
* added **color flow** and **scene** support
