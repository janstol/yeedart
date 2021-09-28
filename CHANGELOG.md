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
