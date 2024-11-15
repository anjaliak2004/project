module Mymodule::DiceRoll {
    use aptos_framework::account;
    use aptos_framework::event::{Self, EventHandle};
    use aptos_framework::timestamp;

    struct DiceRollEvent has drop, store {
        roller: address,
        roll_value: u64,
        timestamp: u64,
    }

    resource struct DiceRollResource has key {
        events: EventHandle<DiceRollEvent>,
    }

    public entry fun roll_dice(account: &signer) acquires DiceRollResource {
        let roller_address = account::address_of(account);
        let roll_value = random_u64() % 6 + 1;

        let dice_roll_resource = borrow_global_mut<DiceRollResource>(@DiceRollGame);
        event::emit_event(&mut dice_roll_resource.events, DiceRollEvent {
            roller: roller_address,
            roll_value,
            timestamp: timestamp::now_seconds(),
        });
    }

    fun random_u64(): u64 {
        // Use the Aptos framework's random number generation
        let seconds = timestamp::now_seconds();
        (seconds * 6364136223846793005 + 1442695040888963407) % 18446744073709551615
    }
}