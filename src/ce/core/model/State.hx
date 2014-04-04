/**
 * Cloud Explorer, lightweight frontend component for file browsing with cloud storage services.
 * @see https://github.com/silexlabs/cloud-explorer
 *
 * Cloud Explorer works as a frontend interface for the unifile node.js module:
 * @see https://github.com/silexlabs/unifile
 *
 * @author Thomas Fétiveau, http://www.tokom.fr  &  Alexandre Hoyau, http://lexoyo.me
 * Copyrights SilexLabs 2013 - http://www.silexlabs.org/ -
 * License MIT
 */
package ce.core.model;

import ce.core.model.unifile.Service;
import ce.core.model.unifile.File;
import ce.core.model.Location;
import ce.core.model.SelectionMode;

import haxe.ds.StringMap;

class State {

	public function new() { }

	public var readyState (default, set) : Bool = false;

	public var displayState (default, set) : Bool = false;

	public var serviceList (default, set) : Null<StringMap<Service>> = null;

	public var currentLocation (default, set) : Null<Location> = null;

	public var currentFileList (default, set) : Null<StringMap<File>> = null;

	public var currentSelectionMode (default, default) : Null<SelectionMode> = null;


	///
	// CALLBACKS
	//

	public dynamic function onReadyStateChanged() { }

	public dynamic function onDisplayStateChanged() { }

	public dynamic function onServiceListChanged() { }

	public dynamic function onCurrentLocationChanged() { }

	public dynamic function onCurrentFileListChanged() { }

	public dynamic function onServiceLoginStateChanged(srvName : String) { }

	public dynamic function onServiceAccountChanged(srvName : String) { }


	///
	// SETTERS
	//

	public function set_serviceList(v : Null<StringMap<Service>>) : Null<StringMap<Service>> {

		if (v == serviceList) {

			return v;
		}
		serviceList = v;

		for (s in serviceList) {

			s.onLoginStateChanged = function() {

				onServiceLoginStateChanged(s.name);
			}
			s.onAccountChanged = function() { onServiceAccountChanged(s.name); }

			if (s.account != null) {

				onServiceAccountChanged(s.name);
			}
		}
		
		onServiceListChanged();

		return serviceList;
	}

	public function set_currentFileList(v : Null<StringMap<File>>) : Null<StringMap<File>> {

		if (v == currentFileList) {

			return v;
		}
		currentFileList = v;
		
		onCurrentFileListChanged();

		return currentFileList;
	}

	public function set_readyState(v : Bool) : Bool {

		if (v == readyState) {

			return v;
		}
		readyState = v;

		onReadyStateChanged();

		return readyState;
	}

	public function set_displayState(v : Bool) : Bool {

		if (v == displayState) {

			return v;
		}
		displayState = v;

		onDisplayStateChanged();

		return displayState;
	}

	public function set_currentLocation(v : Location) : Location {

		if (v == currentLocation) {

			return v;
		}
		currentLocation = v;

		currentLocation.onChanged = function() { onCurrentLocationChanged(); }

		onCurrentLocationChanged();

		return currentLocation;
	}
}