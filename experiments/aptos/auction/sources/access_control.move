module resource_account_addr::access_control {
  use aptos_framework::account;
  use aptos_framework::resource_account;
  use aptos_framework::event;
  use aptos_framework::signer;

  friend resource_account_addr::auction;
  friend resource_account_addr::auction_simple;
  friend resource_account_addr::token;
  #[test_only]
  friend resource_account_addr::tests;

  const ENOT_ADMIN: u64 = 0;

  struct AccessControl has key {
    resource_signer_cap: account::SignerCapability,
    admin: address,
    admin_change_events: event::EventHandle<AdminChangeEvent>,
  }

  struct AdminChangeEvent has drop, store {
    old_admin: address,
    new_admin: address
  }

  fun init_module(account: &signer) {
    let resource_cap = resource_account::retrieve_resource_account_cap(account, @source_addr);
    move_to(
      account,
      AccessControl {
        resource_signer_cap: resource_cap,
        admin: @source_addr,
        admin_change_events: account::new_event_handle<AdminChangeEvent>(account)
      }
    );
  }

  public(friend) fun get_signer(): signer acquires AccessControl {
    let resource_signer = account::create_signer_with_capability(
      &borrow_global<AccessControl>(@resource_account_addr).resource_signer_cap
    );
    resource_signer
  }

  public(friend) fun admin_only(account: &signer) acquires AccessControl {
    assert!(signer::address_of(account) == get_admin(), ENOT_ADMIN);
  }

  public entry fun change_admin(account: &signer, new_admin: address) acquires AccessControl {
    admin_only(account);
    let access_control = borrow_global_mut<AccessControl>(@resource_account_addr);
    access_control.admin = new_admin;
    event::emit_event(
      &mut access_control.admin_change_events,
      AdminChangeEvent {
        old_admin: signer::address_of(account),
        new_admin
      }
    );
  }

  #[view]
  public fun get_admin(): address acquires AccessControl {
    borrow_global<AccessControl>(@resource_account_addr).admin
  }

  #[test_only]
  public fun init_module_test(account: &signer) {
    move_to(
      account,
      AccessControl {
        resource_signer_cap: account::create_test_signer_cap(signer::address_of(account)),
        admin: @source_addr,
        admin_change_events: account::new_event_handle<AdminChangeEvent>(account)
      }
    );
  }
}