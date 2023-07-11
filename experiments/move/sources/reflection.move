module deploy_address::reflection {

	use aptos_std::type_info;
	use aptos_std::debug::print;
	use std::string::{String, utf8};
  	use aptos_std::string_utils;

	struct Resource has key, drop {
		value: u64,
		string_value: String,
	}

	public fun print_type_info<T>() {
		let ti = type_info::type_of<T>();
		print(&23);
		print(&type_info::account_address(&ti));
 		print(&string_utils::to_string(&utf8(type_info::module_name(&ti))));
		print(&string_utils::to_string(&utf8(type_info::struct_name(&ti))));
	}

	#[test]
	public fun test1() {
		print_type_info<Resource>();
	}

	#[test]
	public fun test2() {
		print_type_info<u64>();
	}

	/*#[test]
	fun print_test() {
		let resource = Resource {
			value: 1337,
			string_value: string::utf8(b"String example!"),
		};
		
		let formatted_string = string_utils::to_string(&resource);
		print(&formatted_string);
	}*/

}

