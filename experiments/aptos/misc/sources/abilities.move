module deploy_address::abilities {

	const K: u8 = 90;

	struct Caz has copy {
		u: u8
	}

	struct Country has copy { 
        id: u8,
        population: u64,
		caz: Caz
    }

	public fun clone(c: Country): Country {
		let Country { id: _id, population, caz: Caz { u } } = c;
		let r = Country { id: c.id, population, caz: Caz { u: u + K } };
		destroy(c);
		r
	}

	public fun destroy(t: Country) {
        let Country { id: _id, population: _pop, caz: Caz { u: _u } } = t;
    }

	public fun main() {
		let a = Country { id: 7, population: 80, caz: Caz { u: K } };
		let b = clone(a);
		destroy(b)
	}


}
