module tid_game::escrow {

    use sui::coin::{Coin, join, value};
    use sui::sui::SUI;
    use std::option::{none, some, is_some, extract, borrow};

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
        wager: Option<Coin<SUI>>,
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
        assert!(value(&wager) > 0, 0);
        transfer::share_object(Escrow {
            id: object::new(ctx),
            challenger_a: tx_context::sender(ctx),
            challenger_b: none(),
            wager: some(wager),
        });
    }

    public fun join_escrow(escrow: &mut Escrow ,wager: Coin<SUI>, ctx: &mut TxContext) {
        assert!(escrow.challenger_a != tx_context::sender(ctx), 0);
        assert!(value(borrow(&escrow.wager)) == value(&wager), 1);
        assert!(is_some(&escrow.wager), 2);
        escrow.challenger_b = some(tx_context::sender(ctx));

        join(option::borrow_mut(&mut escrow.wager), wager);


    }

    public fun challenger_a_cancle_escrow(escrow: &mut Escrow, ctx: &mut TxContext) {
        assert!(escrow.challenger_a == tx_context::sender(ctx), 0);
        assert!(!is_some(&escrow.challenger_b),1);
        let refund_wager = extract(&mut escrow.wager);
        transfer::public_transfer(refund_wager, escrow.challenger_a);
    }

}