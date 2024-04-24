module deploy_address::update_test {

    //use deploy_address::pure_coin::{Self,Coin};

    public struct Nested has store {
        a: u64
    }

	public struct MySharedObject<phantom T> has key {
        id: UID,
//      coin: Coin<T>,	// campo lineare extra modulo, ma non posso accedere ai suoi campi, quindi siamo fregati
        amt: u64,       // campo non-lineare
        nested: Nested, // campo lineare con campo interno non-lineare
    }


    // funzione che pasticcia un po' con l'oggetto
    // versione classica con reference e sidefx
    public entry fun do_something<T>(self: &mut MySharedObject<T>, _ctx: &mut TxContext) {
        self.amt = self.amt + 1;
        self.nested.a = self.nested.a + 1;
    }

    // versione pura riscritta da noi
    // particolare non trascurabile: e' necessario passare self in input e ritornarlo in output, altrimenti rompiamo la linearita'
    // questo non solo e' scomodo, ma e' anche difficile scrivere il wrapper, come vedremo sotto
    fun do_something_pure<T>(self: MySharedObject<T>, ctx: &mut TxContext): (MySharedObject<T>, MySharedObject<T>) {
        let new = MySharedObject<T> {
            id: object::new(ctx),  // serve fare uno UID nuovo perché UID è non-copiable
            amt: self.amt + 1,
            nested: Nested { a: self.nested.a + 1 }
        };
        (new, self)
    }

    // versione pura riscritta da noi ma col reference in sola lettura
    // per non passare e riprendere self, passiamo il reference in sola lettura
    // questo implicherebbe che non abbandoniamo i reference del tutto, solo quelli mutable non ci servono
    fun do_something_pure_ref<T>(self: &MySharedObject<T>, ctx: &mut TxContext): MySharedObject<T> {
        MySharedObject<T> {
            id: object::new(ctx),  // mi tocca fare uno UID nuovo, perché UID è non-copiable
            amt: self.amt + 1,
            nested: Nested { a: self.nested.a + 1 }
        }
    }

    // wrapper della versione pura
    // maniente la firma dell'originale di Sui
    // chiama la versione pura con reference non-mutable e poi fa un update
    // attenzione: scrivere il wrapper per la versione pura senza reference e' impossibile, perché non si può de-referenziare un tipo lineare
    public entry fun do_something_pure_ref_wrapper<T>(self: &mut MySharedObject<T>, ctx: &mut TxContext) {
        let new = do_something_pure_ref(self, ctx);
        update(self, new)
    }


    // funzione di update
    fun update<T>(self: &mut MySharedObject<T>, new: MySharedObject<T>) {
        let MySharedObject { id, amt, nested: Nested { a } } = new; // unpacking che evita i campi lineari, i quali necessitano di unpacking ricorsivi fino ad arrivare ai campi "foglia" non-lineari
        // aggiorniamo i campi dell'oggetto originale
        self.amt = amt;
        self.nested.a = a;
        // cancelliamo l'oggetto nuovo che abbiamo appena copiato su quello vecchio
        id.delete();
    }
	
}
