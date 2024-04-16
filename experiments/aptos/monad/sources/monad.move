module deploy_address::monad {

	use std::vector;

	inline fun curry<A, B, C>(f: |A,B|C): |A|(|B|C) {
		|x| (|y| f(x, y))
	}


	inline fun run<S, R>(s: S, f: |S|(R, S)): (R, S) {
		f(s)
	}

	inline fun ret<S, R>(r: R): |S|(R, S) {
		|s| (r, s)
	}

	inline fun bind<S, R>(f: |S|(R, S), s: |S|(R, S)) {
		
	}

}
