module deploy_address::monad {

	use std::vector;

	inline fun run<S, R>(s: S, f: |S|(R, S)): (R, S) {
		f(s)
	}

	inline fun ret<S, R>(r: R): |S|(R, S) {
		// servono le lambda qua
	}

	inline fun bind<S, R>(f: |S|(R, S), s: |S|(R, S)): u64 {
		
	}

}
