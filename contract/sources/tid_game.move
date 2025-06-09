module tid_game::escrow {

    use sui::coin::{Coin, join, value};
    use sui::sui::SUI;
    use std::option::{none, some};

    public struct Owner_cap has key, store { id: UID }

    public struct Tid_game has key, store {
        id: UID,
        owner: ID,
    }

    #[allow(lint(coin_field))]
    public struct Escrow has key {
        id: UID,
        challenger_a: address,
        challenger_b: Option<address>,
        wager: Coin<SUI>,
    }

    fun init (ctx: &mut TxContext) {
        let owner_cap = Owner_cap {
            id: object::new(ctx),
        };

        transfer::share_object(Tid_game {
            id: object::new(ctx),
            owner: object::id(&owner_cap),
        });

        transfer::transfer(owner_cap, tx_context::sender(ctx));
    }
    
    #[allow(lint(coin_field))]
    public fun create_escrow(wager: Coin<SUI>, ctx: &mut TxContext) {
        transfer::share_object(Escrow {
            id: object::new(ctx),
            challenger_a: tx_context::sender(ctx),
            challenger_b: none(),
            wager: wager,
        });
    }

    public fun join_escrow(escrow: &mut Escrow ,wager: Coin<SUI>, ctx: &mut TxContext) {
        assert!(escrow.challenger_a != tx_context::sender(ctx), 0);
        assert!(value(&escrow.wager) == value(&wager), 1);
        escrow.challenger_b = some(tx_context::sender(ctx));

        join(&mut escrow.wager, wager);

    }

}