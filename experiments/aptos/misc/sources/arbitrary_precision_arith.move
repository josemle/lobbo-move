module deploy_address::arbitrary_precision_arith {

	const K: num = 90;

	public fun main() {
		let a = Country { id: 7, population: 80, caz: Caz { u: K } };
		let b = clone(a);
		destroy(b)
	}


}
